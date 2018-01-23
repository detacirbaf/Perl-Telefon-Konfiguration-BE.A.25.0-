use warnings;
use strict;
use diagnostics;
use IO::Socket::INET;
use Data::Netflow
use feature 'say';

my $socket = IO::Socket::INET->new(
	lokalerPort => 8888,
	eProtokoll => 'udp'
);

open my $eLog, '>>', 'phone.log' or die $!;

my ($sender, $datagram);
while ($sender = $socket->recv($datagram, 0xFFFF))
{
	my ($sender_port, $sender_addr) = unpack_sockaddr_in($sender);
	$sender_addr = inet_ntoa($sender_addr);
	my ($headers, $records) = Data::Netflow::decode($datagram, 1);

	for my $r (@$records) {
		if ($r->{SrcAddr} eq 'xxx.xxx.xxx.xxx' or 'xxx.xxx.x.xxx' && $r->{DstAddr} ne 'xxx.xxx.x.x' or 'xxx.xxx.xxx.xxx') {
			say $eLog "%s, %d, %d, %d, %d\n", $r->{DstAddr}, $r->{DstPort}, $r->{Packets}, $r->{Octets}, time;
		}
	}
}

