#!/usr/bin/env perl
use Mojolicious::Lite;

use lib::abs '.';
use TalkRating;

get '/' => sub {
    my $c = shift;

    my @talks = sort {
            $b->{votes} <=> $a->{votes}
    } sort {
        $a->{speaker} cmp $b->{speaker}
    } TalkRating->parse_talks;
    $c->render(template => 'index', talks => \@talks);
};

app->start;
__DATA__

@@ index.html.ep
% layout 'default';
% title 'Рейтинг докладов 2.0';

<h1>Рейтинг докладов 2.0</h1>

<table id="talk-rating">
    <tr>
        <th>№</th>
        <th>Докладчик</th>
        <th>Тема</th>
        <th>Голосов</th>
    </tr>
% for my $i (0 .. $#$talks) {
%   my $talk = $talks->[$i];
    <tr>
        <td><%= $i + 1 %></td>
        <td><%= $talk->{speaker} %></td>
        <td><a target="blank" href="http://nastachku.ru/user_lectures?lecture_id=<%= $talk->{id} %>"><%= $talk->{title} %></a></td>
        <td><%= $talk->{votes} %></td>
    </tr>
% }
</table>

@@ layouts/default.html.ep
<!DOCTYPE html>
<html>
    <head>
        <title><%= title %></title>
        <style>
            table {
                width: 100%; /* Ширина таблицы */
                border: 1px solid #399; /* Граница вокруг таблицы */
                border-spacing: 7px 5px; /* Расстояние между границ */
            }
            td {
                background: #fc0; /* Цвет фона */
                border: 1px solid #333; /* Граница вокруг ячеек */
                padding: 5px; /* Поля в ячейках */ 
            }
        </style>
    </head>
    <body><%= content %></body>
</html>
