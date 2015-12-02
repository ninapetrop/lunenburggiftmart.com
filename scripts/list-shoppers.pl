#!/usr/bin/perl

# list-shoppers.pl - Prints a list of shoppers, invitations, and giftees

use warnings;
use strict;

use FindBin;

use lib "$FindBin::Bin/../lib";
use Giftmart::Register;

my $register = Giftmart::Register->new();

# Format and display the shoppers
foreach my $shopper ( $register->getShoppers() ) {
	my $shopper_str .= "$shopper->{name}\t$shopper->{town}\t$shopper->{email}\nInvitations:";

	foreach my $invitation ( @{ $shopper->{invitations} } ) {
		$shopper_str .= " $invitation,";
	}
	chop( $shopper_str );
	$shopper_str .= "\nGiftees:";

	foreach my $giftee ( @{ $shopper->{giftees} } ) {
		$shopper_str .= " $giftee->{age}$giftee->{gender},";
	}
	chop( $shopper_str );
	$shopper_str .= "\n\n";

	print $shopper_str;
}
