package Giftmart::Register;
use parent Giftmart;

use strict;

sub newReg {
	my ($self, $params) = @_;
	my $sth;

	# Insert the shopper
	$sth = $self->{dbh}->prepare("INSERT INTO shoppers(name, email, town) VALUES (?, ?, ?)");
	$sth->execute( $params->{name}, $params->{email}, $params->{town} );

	# Get the id of the shopper we just added
	my $shopper_id = $sth->{mysql_insertid};

	# Add shopper's giftees
	foreach my $giftee ( @{ $params->{giftees} } ) {
		$sth = $self->{dbh}->prepare("INSERT INTO giftees(shopper_id, age, gender) VALUES (?, ?, ?)");
		$sth->execute( $shopper_id, $giftee->{age}, $giftee->{gender} );
	}

	# Add shopper's invitation numbers
	foreach my $invitation_number ( @{ $params->{invitation_numbers} } ) {
		$sth = $self->{dbh}->prepare("INSERT INTO invitations(shopper_id, invitation_number) VALUES (?, ?)");
		$sth->execute( $shopper_id, $invitation_number );
	}

	return;
}
sub getShoppers {
	my ($self) = @_;

	# Prepare MySQL statements
	my $sth_shoppers = $self->{dbh}->prepare("SELECT shopper_id AS id, name, email, town FROM shoppers");
	my $sth_giftees = $self->{dbh}->prepare("SELECT age, gender FROM giftees WHERE shopper_id = ?");
	my $sth_invitations = $self->{dbh}->prepare("SELECT invitation_number FROM invitations WHERE shopper_id = ?");

	# Build a list of shoppers objects
	my @shoppers;

	$sth_shoppers->execute();

	while( my $shopper = $sth_shoppers->fetchrow_hashref ) {
		# Build a list of giftee objects
		$sth_giftees->execute( $shopper->{id} );

		while( my $giftee = $sth_giftees->fetchrow_hashref ) {
			push( @{ $shopper->{giftees} }, $giftee );
		}

		# Build a list of invitation numbers
		$sth_invitations->execute( $shopper->{id} );

		while( my ($invitation) = $sth_invitations->fetchrow_array ) {
			push( @{ $shopper->{invitations} }, $invitation );
		}

		push(@shoppers, $shopper);
	}

	return @shoppers;
}
1;
