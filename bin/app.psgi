#!/usr/bin/env perl
use Modern::Perl;

# CPAN modules
use Data::Dump qw<dump>;
use Data::Printer;
use DateTime;
use DBIx::Class::ResultClass::HashRefInflator;
use JSON;
use Mojo::IOLoop;
use Mojolicious::Lite;
use Try::Tiny;

# Local Modules
use GameMatcher::Schema;

my $j       = JSON->new;
my $players = {};
my $matches = [];
my $schema;

try {
    $schema = GameMatcher::Schema->connect(
        'dbi:SQLite:dbname=db/game_matcher.sqlite',
        '',
        '', 
        {
            AutoCommit => 1,
            RaiseError => 1,
            on_connect_call => 'use_foreign_keys',
        }
    );
}
catch {
    warn $_;
};

#my $loop_time = time;
our $event_loop = Mojo::IOLoop->recurring(
    1 => sub {
        while( my $match = shift @{$matches} ) {
            foreach ( keys %{$players} ) {
                $players->{$_}->send( $j->encode( { match => $match } ) );
            }
        }
    }
);

#options '*' => sub {
#  my $self = shift;
#  $self->res->headers->header('Access-Control-Allow-Origin'=> 'http://localhost:7000');
#  $self->res->headers->header('Access-Control-Allow-Credentials' => 'true');
#  $self->res->headers->header('Access-Control-Allow-Methods' => 'GET, OPTIONS, POST, DELETE, PUT');
#  $self->res->headers->header('Access-Control-Allow-Headers' => 'Content-Type, X-CSRF-Token');
#  $self->res->headers->header('Access-Control-Max-Age' => '1728000');
# 
#  $self->respond_to(any => { data => '', status => 200 });
#};

get '/' => sub {
    my $self = shift;
    $self->render( text => "root" );
};

post 'register' => sub {
    my $self = shift;

    try {
        return $self->render_json({});
    }
    catch {
        warn "Error during registation process: $_";
        return $self->render_json({ error => "Error during registration process." });
    };
};

post '/login' => sub {
    my $self = shift;

    return try {
        return $self->render_json({});
    }
    catch {
        warn "Error logging in: $_";
        return $self->render_json({ error => "Error logging in." })
    };

};

get '/players/all' => sub {
    my $self = shift;
    set_cors($self);

    return try {
        my @players
            = $schema->resultset('GameMatcher::Schema::Result::Players')
            ->search(
            { },
            {
                select => [ 'avatar', 'created', 'last_login', 'name', 'nickname' ],
                order_by => 'nickname ASC',
                result_class => 'DBIx::Class::ResultClass::HashRefInflator',
            }
            )->all();
            return $self->render_json({ players => \@players } );
    }
    catch {
        warn "Error getting list of matches: $_";
        return $self->render({ json => { error => "Error getting list of matches." } });
    };  
};

get '/games/all' => sub {
    my $self = shift;
    set_cors($self);

    return try {

        my @games
            = $schema->resultset('GameMatcher::Schema::Result::Games')
            ->search(
            { },
            {   order_by => 'name ASC',
                #prefetch => [
                #    'Expansions',
                #],
                result_class => 'DBIx::Class::ResultClass::HashRefInflator',
            }
            )->all();

            return $self->render_json({ games => \@games } );
    }
    catch {
        warn "Error getting list of matches: $_";
        return $self->render({ json => { error => "Error getting list of matches." } });
    };
    
};

get '/matches/all' => sub {
    my $self = shift;
    set_cors($self);
    
    return try {
        my @matches
            = $schema->resultset('GameMatcher::Schema::Result::Matches')
            ->search(
            { },
            {   order_by => 'start_time DESC',
                prefetch => [
                    'Game',
                    { 'MatchesPlayers' => 'player' },
                ],
                result_class => 'DBIx::Class::ResultClass::HashRefInflator',
            }
            )->all();
        return $self->render({ json => { matches => \@matches } });
            
    }
    catch {
        warn "Error getting list of matches: $_";
        return $self->render_json({ error => "Error getting list of matches." });
    };
    
};

post '/matches' => sub {
    my $self = shift;
    set_cors($self);

    try {

        my $all_matches = $schema->resultset('GameMatcher::Schema::Result::Matches');
        my $fields = $self->req->params->to_hash;
        my $new_match = $all_matches->create($fields);
        my %match = $new_match->get_columns();
        my %game = $new_match->Game->get_columns;
        $match{Game} = \%game;
        push @{$matches}, \%match;
        return $self->render_json({ message => 'Successfully created a new match.' });
    }
    catch {
        warn "Error creating new match: $_";
        return $self->render_json({ error => "Error creating new match." })
    };
};

post '/matches/:id/add_player' => sub {
    my $self = shift;
    
    try {
        my $match = $schema->resultset('GameMatcher::Schema::Result::Matches')->find($self->param('id'));
        return $self->render_json({ error => "Could not find match to add player to." }) unless $match;
        my $player = $schema->resultset('GameMatcher::Schema::Result::Players')->find($self->param('player_id'));
        return $self->render_json({ error => "Could not find player to add to match." }) unless $match;
        $match->add_to_players($player);
        return $self->render_json({ message => "Successfully added player '" . $player->nickname . "' to match " . $match->id });
    }
    catch {
        warn "Error creating new match: $_";
        return $self->render_json({ error => "Error creating new match." })
    };    
};

# socket route for polling data live list of matches
websocket '/matches/new' => sub {
    my $self = shift;

    my $id = sprintf "%s", $self->tx;

    app->log->debug( sprintf( "Player connected: %s", $id ) );

    $players->{$id} = $self->tx;
    $self->on(
        finish => sub {
            warn app->log->debug("Client disconnected: $id");
            delete $players->{$id};
        }
    );
};

sub set_cors {
    my $self = shift;
    $self->res->headers->header('Access-Control-Allow-Origin' => '*');
    $self->res->headers->header('Access-Control-Allow-Credentials' => 'true');
    $self->res->headers->header('Access-Control-Allow-Methods' => 'GET, OPTIONS, POST, DELETE, PUT');
    $self->res->headers->header('Access-Control-Allow-Headers' => 'Content-Type, X-CSRF-Token');
    $self->res->headers->header('Access-Control-Max-Age' => '1728000');
}

app->secret('whencountingfishbeforerunningamarathononeshouldalwaysmakesuretotkeintoaccountallhelicopters');
app->start;
