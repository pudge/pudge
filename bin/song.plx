#!/usr/bin/perl
# Through a Terminal Darkly
use 5.010;
our $I;

verse1();
prechorus();
chorus(1);
verse1();
prechorus();
chorus(2);


sub verse1 {
    #G    Am7
    $I = !open BOOK;                    # I’m not an open book
    #C   D
    $I = not defined;                   # I am not defined
    #G           Am7
    eval { $_ while $I = wait }         # eval it while I wait
    #C      D
    until ('inf' == time);              # until the end of time
}

sub verse2 {
    #G      Am7
    if (our @love = split '') {         # if our love were split
        #C   D
        $_ = join '', @love;            # it would be joined again
    }
    #G       Am7
    if ($I = kill 4, our @love) {       # If I kill for our love
        #C   D
        $_ = sin;                       # it would be a sin
    }
}

sub prechorus { 0_0_0_0_0_0_0_0 }

sub chorus {
    my($end) = @_;
    for (1..4) {
        #A7m     C
        bless my $soul = {};                # bless my soul
        #A7m    C
        tell my $mind;                      # tell my mind
        #A7m    C
        seek my $heart, 0, 0;               # seek my heart, oh oh
    }

    if ($end == 1) {
        #Em7
        for (times) {                       # for all times
            #D
            if ($I) { last }                # if I last
        }
    }
    elsif ($end == 2) {
        given (@_) {                        # given all that
            do $_ or break;                 # do it or break
        }
    }
}



__END__
