#!/usr/bin/env perl

use Mojolicious::Lite;
use JSON::Schema;
use FindBin;

use lib "$FindBin::Bin/lib";
use Giftmart::Register;

# ALL GLORY TO HYPNOTOAD
app->config(
	hypnotoad => {
		listen => ['http://*:8080'],
		proxy  => 1
	}
);

app->defaults({
	error => {},
	field => {}
});

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

post '/register' => sub {
	my ($c) = @_;

	$c->stash( title => 'Register' );

	my $params = $c->req->params->to_hash;

	#JSON schema validator
	my $invitation_validator = JSON::Schema->new({
		properties => {
			name => {
				minLength => 1,
				type      => 'string',
				error     => 'Please provide your name.'
			},
			town => {
				minLength => 1,
				type      => 'string',
                error     => 'Please provide your City / Town'
			}
		}
	}, format => \%JSON::Schema::FORMATS);

	my $invitation_result = $invitation_validator->validate( $params );

	# Parse invitation numbers
	my @invitation_numbers = ();

	foreach my $number( split(/\D+/, $params->{invitation_number}) ) {
		push(@invitation_numbers, $number);
	}

	# Build a hash of giftees
	my $giftees_hash = {};

	while( my ($name, $value) = each( %{$params} ) ) {
		if( my ( $key, $number ) = $name =~ m/^giftee_(age|gender)_new(\d+)/ ) {
			$giftees_hash->{$number}->{$key} = $value;
		}
	}

	# Loop through giftees hash and build an array of giftees
	my @giftees = ();
	foreach my $giftee ( values %{ $giftees_hash } ) {
		# Throw out empty fields
		if( $giftee->{age} && $giftee->{gender} ) {
			push(@giftees, $giftee);
		}
	}

	# Check if fields are valid, that there is at least one giftee, and at least one valid invitation number
	if( $invitation_result && @giftees && @invitation_numbers ) {
		# Store registration in database
		my $register = Giftmart::Register->new();
		$register->newReg({
			name  => $params->{name},
			email => $params->{email},
			town  => $params->{town},
			giftees            => \@giftees,
			invitation_numbers => \@invitation_numbers
		});

		$c->stash( success => 1 );
	} else {
		# Build an errror object and re-render the form with error messages
		my $error_obj = {};

		# Check for JSON schema errors
		foreach my $error ( $invitation_result->errors ) {
			my ($key) = $error->{property} =~ /\$\.(.+)/;
			$error_obj->{ $key } = $invitation_validator->schema->{properties}->{ $key }->{error};
		}

		# Check if no giftees were given
		if( !@giftees ) {
			$error_obj->{'giftee'} = "Please specify at least one person you are shopping for.";
		}

		# Check if no valid invitation numbers were given
		if( !@invitation_numbers ) {
			$error_obj->{'invitation_number'} = "Please specify at least one invitation number.";
		}

		$params->{giftees} = \@giftees;
		$c->stash( success => 0, error => $error_obj, field => $params );
	}

	$c->stash( title => 'Register', name => $params->{name} );
	$c->render( template => 'register' );
};

app->start;
