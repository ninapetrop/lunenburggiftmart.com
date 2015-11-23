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
1;
