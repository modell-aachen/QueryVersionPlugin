#!/usr/bin/perl -w
# Standard preamble
use strict;
BEGIN { unshift @INC, split(/:/, $ENV{FOSWIKI_LIBS}); }
use Foswiki::Contrib::Build;

package QueryVersionPluginBuild;
our @ISA = qw(Foswiki::Contrib::Build);

sub new {
  my $class = shift;
  return bless($class->SUPER::new("QueryVersionPlugin"), $class);
}

my $build = QueryVersionPluginBuild->new('QueryVersionPlugin');
$build->build($build->{target});
