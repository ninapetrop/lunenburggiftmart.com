#!/usr/bin/env perl

use Mojolicious::Lite;

# ALL GLORY TO HYPNOTOAD
app->config(
	hypnotoad => {
		listen => ['http://*:8080'],
		proxy  => 1
	}
);

any '/' => sub {
	my ($c) = @_;

	$c->stash( title => 'Home' );
	$c->render( template => 'index' );
};

any '/about' => sub {
	my ($c) = @_;

	$c->stash( title => 'About Us' );
	$c->render( template => 'about' );
};

any '/donate' => sub {
	my ($c) = @_;

	$c->stash( title => 'Donate' );
	$c->render( template => 'donate' );
};

any '/press' => sub {
	my ($c) = @_;

	$c->stash( title => 'Press' );
	$c->render( template => 'press' );
};

any '/contact' => sub {
	my ($c) = @_;

	$c->stash( title => 'Contact' );
	$c->render( template => 'contact' );
};

get '/register' => sub {
	my ($c) = @_;

	$c->stash( title => 'Register' );
	$c->render( template => 'register' );
};

app->start;
