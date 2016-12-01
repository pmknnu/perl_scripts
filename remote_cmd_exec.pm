package dcc_sme_smavd::remote_cmd_exec;

use strict;
use warnings;


use Net::SSH::Perl;

use Exporter qw (import);

use LWP::UserAgent; 
use HTTP::Request; 
use HTTP::Response; 
use URI::Heuristic;

our @EXPORT_OK = qw (remote_cmd_exec browse_url);


sub remote_cmd_exec {
	my $host=shift;
	my $ssh_username=shift;
	my $ssh_password=shift;
	my $cmd=shift;
	#print ($host,$ssh_username,$ssh_password,$cmd);
	my $ssh = Net::SSH::Perl->new($host);
	$ssh->login("$ssh_username","$ssh_password");
	my ($stdout,$stderr,$exit)=$ssh->cmd("$cmd");
	return ($stdout,$stderr,$exit);
}


sub browse_url {
	my $raw_url = shift or die "pass url argument to browse_url function";
	my $url = URI::Heuristic::uf_urlstr($raw_url);
	
	my $ua = LWP::UserAgent->new(); 
	$ua->agent("Schmozilla/v9.14 Platinum"); # give it time, it'll get there
	my $req = HTTP::Request->new(GET => $url); 
	$req->referer("http://wizard.yellowbrick.oz");
	my $response = $ua->request($req);
        if ($response->is_error()) {
             printf " %s\n", $response->status_line;
      }
	 else {
	     printf " %s \n", $response->status_line;
	}
}
1;
