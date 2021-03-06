(function() {

    $(function() {
        var App;
        App = Em.Application.create();

        // CONTROLLERS
        App.ApplicationController = Em.Controller.extend();

        App.WellController = Em.Controller.extend();

        App.MatchesController = Em.ArrayController.create({
            content: [],
            init: function() {
                var self = this;
                self._super();
                var promise = $.ajax({
                    url: 'http://localhost:5001/matches/all',
                    type: 'GET',
                    dataType: 'JSON',
                    success: function(data) {
                        for ( var i = 0 ; i < data.matches.length ; i++ ) {
                            console.log(data.matches[i]);
                            self.pushObject(App.Match.create(data.matches[i]));
                        }
                    },
                    error: function(x, y, z) {
                        console.log(x);
                        console.log(y);
                        console.log(z);
                    }
                });
                //promise.done(websocket_connect('ws://localhost:5001/matches/new', self));
                //return self.content;
            },
            addMatch: function(match) {
                //this.pushObject(Em.Object.create(match));
            }
        });

        App.GamesController = Em.ArrayController.create({
            content: [],
            init: function() {
                var self = this;
                self._super();
                $.ajax({
                    url: 'http://localhost:5001/games/all',
                    type: 'GET',
                    dataType: 'JSON',
                    success: function(data) {
                        for ( var i = 0 ; i < data.games.length ; i++ ) {
                            self.pushObject(Em.Object.create(data.games[i]));
                        }
                    },
                    error: function(x, y, z) {
                        console.log(x);
                        console.log(y);
                        console.log(z);
                    }
                });
                //return this.content;
            }
        });

        App.PlayersController = Em.ArrayController.create({
            content: [],
            init: function() {
                var self = this;
                self._super();
                $.ajax({
                    url: 'http://localhost:5001/players/all',
                    type: 'GET',
                    dataType: 'JSON',
                    success: function(data) {
                        for ( var i = 0 ; i < data.players.length ; i++ ) {
                            self.pushObject(Em.Object.create(data.players[i]));
                        }
                    },
                    error: function(x, y, z) {
                        console.log(x);
                        console.log(y);
                        console.log(z);
                    }
                });
                //return this.content;
            }
        });

        // OBJECTS
        App.Match = Ember.Object.extend();
        App.Match.reopenClass({
            Game: {
                created: '',
                description: '',
                id: '',
                max_players: '',
                min_players: '',
                name: '',
                optimal_players: '',
                playtime: ''
            },
            MatchesPlayers: [],
            game: '',
            id: '',
            location: '',
            start_time: ''
            
        });

        // VIEWS
        App.MainView = Em.View.extend({
            templateName: 'main'
        });

        App.MenuView = Em.View.extend({
            templateName: 'menu',
            classNames: ['navbar','navbar-fixed-top']
        });

        App.WellView = Em.View.extend({
            templateName: 'well',
            classNames: ['well', 'well_extras']
        });

        App.MatchesView = Em.View.extend({
            templateName: 'matches',
            controllerBinding: 'App.MatchesController',
            contentBinding: 'controller.content'
        });

        App.GamesView = Em.View.extend({
            templateName: 'games',
            controllerBinding: 'App.GamesController',
            contentBinding: 'controller.content'
        });

        App.PlayersView = Em.View.extend({
            templateName: 'players',
            controllerBinding: 'App.PlayersController',
            contentBinding: 'controller.content'
        });

        // ROUTER
        App.Router = Em.Router.extend({
            //enableLogging: true,
            location: 'hash',
            root: Em.Route.extend({
                goToMatches: Ember.Route.transitionTo('matches'),
                goToGames: Ember.Route.transitionTo('games'),
                goToPlayers: Ember.Route.transitionTo('players'),

                index: Em.Route.extend({
                    route: '/',
                    redirectsTo: 'matches'
                }),

                matches: Em.Route.extend({
                    route: '/matches',
                    connectOutlets: function(router, context) {
                        return router.get('applicationController').connectOutlet({
                            name: 'matches'                        
                        });
                    },
                    enter: function() {
                        return Em.run.next(function() {
                            $('#matches_tab').addClass('active');
                        });
                    },
                    exit: function() {
                        return $('#matches_tab').removeClass('active');
                    }
                }),

                games: Em.Route.extend({
                    route: '/games',
                    connectOutlets: function(router, context) {
                        return router.get('applicationController').connectOutlet({
                            name: 'games'
                        });
                    },
                    enter: function() {
                        return Em.run.next(function() {
                            $('#games_tab').addClass('active');
                        });
                    },
                    exit: function() {
                        return $('#games_tab').removeClass('active');
                    }
                }),

                players: Em.Route.extend({
                    route: '/players',
                    connectOutlets: function(router, context) {
                        return router.get('applicationController').connectOutlet({
                            name: 'players'
                        });
                    },
                    enter: function() {
                        return Em.run.next(function() {
                            $('#players_tab').addClass('active');
                        });
                    },
                    exit: function() {
                        return $('#players_tab').removeClass('active');
                    }
                })
            })
        });

        window.App = App;
        return App.initialize();
    });

}).call(this);


var socket;
function websocket_connect(url, container) {
    if ( typeof(socket) !== "undefined" ) {
        socket.onclose = function () {};
        socket.close();
        $("#connection_status").text("Disconnected");
    }
    socket = new WebSocket(url);
    socket.onopen = function() {
        $("#connection_status").text("Connected");
    };
    socket.onmessage = function(e) {
        var data = JSON.parse(e.data);
        console.log(data);
        if (data.hasOwnProperty('message')) {
            return
        }
        else {
            container.addMatch(data.match);
        }
    };
    socket.onclose = function(e) {
        $("#connection_status").text("Disconnected");
        setTimeout(function(){websocket_connect(url)}, 5000);
    };
}