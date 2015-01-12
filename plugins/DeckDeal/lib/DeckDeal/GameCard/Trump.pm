package DeckDeal::GameCard::Trump;
use strict;

my $detail =<<EOS
The game card.
4 suits - spades, hearts, diamond and club has each 13 card,
2-9 number card and Ace(1), Jack(11), Queen(12), King(13).
Optionally: two JOKER, red and black.
EOS

my $cardTypeData = {
  'name' => 'Game Card TRUMP',
  'count' => '54',
  'detail' => $detail,
};

my @types = [
  'spade',
  'hart',
  'diamond',
  'club',
];

my $labels = {
  1 => 'Ace',
  11 => 'Jack',
  12 => 'Queen',
  13 => 'King',
};

my @extraCards = [
  [ 'red joker', 'Joker', 'red', 2147483647 ],
  [ 'black joker', 'Joker', 'black', 2147483647 ],
];

sub init {
  my $class_name = 'cardtype';
  my $ctClass = MT->model($class_name);
  return if $ctClass->count({ name => $cardTypeData->name });

  my $cardtype = $ctClass->new();
  $cardtype->name($cardTypeData->name);
  $cardtype->count($cardTypeData->count);
  $cardtype->detail($cardTypeData->detail);
  $cardtype->save() or die $cardtype->errstr();

  $class_name = 'card';
  my $class = MT->model($class_name);
  return if $class->count({ cardtype_id => $cardTypeData->id }) == $cardTypeData->count;

  foreach my $suit (@types) {
    for (my $value = 1; $value < 14; ++$value) {
      my $card = $class->new();
      my $label = $labels->{$value} || $value
      $card->name($suit . ' ' . $label);
      $card->label($label);
      $card->value($value);
      $card->option(0);
      $card->save() or die $card->errstr();
    }
  }
  
  foreach my $extra (@extraCards) {
    my $card = $class->new();
    $card-name($extra[0]);
    $card->label($extra[1]);
    $card->type($extra[2]);
    $card->value($extra[3]);
    $card->option(1);
    $card->save() or die $card->errstr();
  }
};

1;