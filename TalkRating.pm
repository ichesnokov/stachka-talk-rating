package TalkRating;

use v5.12;
use warnings;
use Mojo::UserAgent;
use Carp qw(croak);

sub parse_talks {

    my $ua       = Mojo::UserAgent->new;
    my $response = $ua->get('http://nastachku.ru/user_lectures')->res;
    if ($response->code != 200) {
        croak 'Error getting response: '
            . $response->code . ', '
            . $response->message;
    }

    my @talks;
    $response->dom->at('.lectures__items')->find('.lectures__item')->each(
        sub {
            my ($speaker, $title, $votes) =  (
                $_->at('.lectures__item-name b')->text,
                $_->at('.lectures__item-about h4')->text,
                $_->find('.lecture_voting_count')->last->text,
            );
            push @talks,
                {
                    speaker => $speaker,
                    title   => $title,
                    votes   => $votes
                };
        }
    );
    return @talks;
}

1;
