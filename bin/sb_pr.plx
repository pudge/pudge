#!/usr/local/bin/perl
use warnings;
use strict;
use feature ':5.10';

use Data::Dumper; $Data::Dumper::Sortkeys=1;
use Date::Format 'time2str';
use Date::Parse 'str2time';
use URI::Escape 'uri_escape';
use HTML::Entities 'encode_entities';
use utf8;

use Marchex::Client::GitHub;
my $gh = new Marchex::Client::GitHub;

my $file = "$ENV{HOME}/.sb_pr.html";
my $name = 'pudge';
my $org = 'shiftboard';

my $is_pr   = 'is:pr';
my $is_open = 'is:open';
my $is_org  = "org:$org";
my $author  = "author:$name";
my $assign  = "assignee:$name";
my $base_filter = "$is_open $is_pr $is_org";
my %filters = (
    'In Progress'  => {
        order   => 0,
        filters => ["$base_filter -label:staging -label:production"],
        aa      => 1
    },
    'Staging'      => {
        order   => 1,
        filters => ["$base_filter label:staging -label:production"],
        aa      => 1
    },
    'Completed'    => {
        order   => 2,
        filters => ["$base_filter label:production"],
        aa      => 1
    },
    'Involved'     => {
        order   => 3,
        filters => ["$base_filter involves:$name"]
    },
    'Other'        => {
        order   => 4,
        filters => ["$base_filter -involves:$name"]
    },
);

my $out;
my %seen;

for my $type (sort { $filters{$a}{order} <=> $filters{$b}{order} } keys %filters) {
    my @filters;
    if ($filters{$type}{aa}) {
        for my $q (@{$filters{$type}{filters}}) {
            push @filters, "$q $author", "$q $assign";
        }
    }
    else {
        @filters = @{$filters{$type}{filters}}
    }

    $out .= type_start_html($type, \@filters);

    my @issues;
    for my $q (@filters) {
        my $issues = $gh->command(GET => 'search/issues', {
            'q'     => $q
        });
#        print Dumper $issues;
        for my $issue (@{$issues->{items}}) {
            next if $seen{$issue->{html_url}}++;
            push @issues, $issue;
        }
    }

    for my $issue (sort { $b->{updated_at} cmp $a->{updated_at} } @issues) {
        $out .= issue_html($issue);
    }

    $out .= type_end_html();
}


write_html($out);
exit;

#======================
# helpers
#======================

sub write_html {
    my($out) = @_;
    my $html = main_html();
    $html =~ s/__BODY__/$out/;
    open my $fh, '>:encoding(UTF-8)', $file;
    print $fh $html;
    close $fh;
}

sub date {
    my($iso8601) = @_;
    my $time = str2time($iso8601);
    return time2str('%Y-%m-%d %X', $time);
}

sub query_url {
    my($query) = @_;
    return sprintf "https://github.com/issues?q=%s", uri_escape($query);
}

sub contrast_color {
    my($bgcolor) = @_;

    my($r, $g, $b) = map { hex } $bgcolor =~ /^(..)(..)(..)$/;
    # perceptive luminance 
    my $a = 1 - ( 0.299 * $r + 0.587 * $g + 0.114 + $b)/255;

    if ($a < 0.5) {
       return '000';
    }
    else {
        return 'fff';
    }
}


#======================
# templates
#======================

sub type_start_html {
    my($type, $filters) = @_;
    my $filter_html = '';

    my $c = 0;
    for my $filter (@$filters) {
        my $query_url_html = encode_entities(query_url($filter));
        $filter_html .= qq{ <a href="$query_url_html" class="link-gray-dark text-small">[$c]</a>};
        $c++;
    }

    return <<EOT;

<div class="p-3">
<span class="text-gray-dark h3">$type</span>$filter_html

<ul>
EOT
}

sub type_end_html {
    return <<'EOT';

</ul>
</div>

EOT
}

sub issue_html {
    my($issue) = @_;

    my $pr = $gh->command(GET => $issue->{pull_request}{url});
    my $repo = $pr->{base}{repo}{full_name};

    my $assignees = '';
    if (@{$issue->{assignees}}) {
        $assignees = ' - assigned to ' . join ', ', map { user_html($_) } @{$issue->{assignees}};
    }

    my $created = date($issue->{created_at});
    my $updated = date($issue->{updated_at});
    my $user = user_html($issue->{user});
    my $labels = '';
    for my $label (@{$issue->{labels}}) {
        my $color = $label->{color};
        my $label_color = contrast_color($color);
        $labels .= qq{ <span class="label v-align-text-top labelstyle-$color" style="background-color: #$color; color: #$label_color;">$label->{name}</span>};
    }

    return <<EOT;

<li class="lh-condensed Box-row Box-row--focus-gray navigation-focus">
    <a href="$issue->{repository_url}" class="muted-link h4">$repo</a>
    <a href="$issue->{html_url}" class="link-gray-dark h4">$issue->{title}</a>
    $labels
    <div class="mt-1 text-small text-gray">
        #$issue->{number} created $created - updated $updated
        <a href="$pr->{head}{repo}{html_url}/tree/$pr->{head}{ref}" class="branch-name">$pr->{head}{ref}</a>
    </div>
    <div class="mt-1 text-small text-gray">
        opened by $user$assignees
    </div>
</li>

EOT


}

sub user_html {
    my($user) = @_;
    return <<EOT;
<a href="$user->{html_url}" class="muted-link">
    <img src="$user->{avatar_url}" alt="\@$user->{login}" class="avatar avatar-small" height="16" width="16">
    $user->{login}
</a>
EOT
}

sub main_html {
    return <<'EOT';
<!DOCTYPE html>
<html>
<head>
    <title>Pudge's Shiftboard Pull Requests</title>
    <meta charset="UTF-8" />
    <meta http-equiv="refresh" content="600" />
    <link rel="shortcut icon" href="https://github.com/favicon.ico" />
    <link rel="mask-icon" href="https://assets-cdn.github.com/pinned-octocat.svg" color="#f05624" />
    <link crossorigin="anonymous" href="https://assets-cdn.github.com/assets/frameworks-81a59bf26d881d29286674f6deefe779c444382fff322085b50ba455460ccae5.css" media="all" rel="stylesheet" />
    <link crossorigin="anonymous" href="https://assets-cdn.github.com/assets/github-64951a579f72746470cd6d8d29a3170eb697f3b1e3a7472c5787af321ad3cfc9.css" media="all" rel="stylesheet" />
</head>
<body>

<div style="background-color: #f05624;">
    <a href="https://www.shiftboard.com/">
        <img width="162" height="36" src="https://www.shiftboard.com/wp-content/uploads/2016/06/Shiftboard_Logo_white.png" alt="Shiftboard" />
    </a>
    <a href="https://github.com/shiftboard">
        <svg aria-hidden="true" height="32" version="1.1" viewBox="0 0 16 16" width="32" fill="#fff">
            <path d="M8 0C3.58 0 0 3.58 0 8c0 3.54 2.29 6.53 5.47 7.59.4.07.55-.17.55-.38 0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49-2.69-.94-.09-.23-.48-.94-.82-1.13-.28-.15-.68-.52-.01-.53.63-.01 1.08.58 1.23.82.72 1.21 1.87.87 2.33.66.07-.52.28-.87.51-1.07-1.78-.2-3.64-.89-3.64-3.95 0-.87.31-1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82.64-.18 1.32-.27 2-.27.68 0 1.36.09 2 .27 1.53-1.04 2.2-.82 2.2-.82.44 1.1.16 1.92.08 2.12.51.56.82 1.27.82 2.15 0 3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48 0 1.07-.01 1.93-.01 2.2 0 .21.15.46.55.38A8.013 8.013 0 0 0 16 8c0-4.42-3.58-8-8-8z"></path>
        </svg>
    </a>
</div>

__BODY__

</body>
</html>
EOT
}
