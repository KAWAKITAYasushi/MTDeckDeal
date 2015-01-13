package DeckDeal::GameCard::Trump;
use strict;

my $detail =<<'EOS';
The game card.
4 suits - spades, hearts, diamond and club has each 13 card,
2-9 number card and Ace(1), Jack(11), Queen(12), King(13).
Optionally: two JOKER, red and black.
EOS

sub init {

  my $cardTypeData = {
    name => 'Game Card TRUMP',
    quantity => 54,
    detail => $detail,
  };
  
  my $types = [
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
  
  my $extraCards = [
    [ 'red joker', 'Joker', 'red', 2147483647 ],
    [ 'black joker', 'Joker', 'black', 2147483647 ],
  ];

  my $class_name = 'card_type';
  my $ctClass = MT->model($class_name);

  my $cardtype = $ctClass->get_by_key({ name => $$cardTypeData{name} });
  #$cardtype->name($$cardTypeData{name});
  $cardtype->quantity($$cardTypeData{quantity});
  $cardtype->detail($$cardTypeData{detail});
  $cardtype->save() or die $cardtype->errstr();

  my $typeId = $cardtype->id();
  my $cardCount = $$cardTypeData{quantity};
  $class_name = 'card';
  my $class = MT->model($class_name);

  foreach my $suit (@$types) {
    for (my $value = 1; $value < 14; ++$value) {
      my $label = $labels->{$value} || $value;
      my $card = $class->get_by_key({ name => $suit . ' ' . $label });
      $card->cardtype_id($typeId);
      $card->label($label);
      $card->type($suit);
      $card->value($value);
      $card->option(0);
      $card->save() or die $card->errstr();
    }
  }

  my @jokerIds;
  foreach my $extra (@$extraCards) {
    my $card = $class->get_by_key({ name => $$extra[0] });
    $card->cardtype_id($typeId);
    $card->label($$extra[1]);
    $card->type($$extra[2]);
    $card->value($$extra[3]);
    $card->option(1);
    $card->save() or die $card->errstr();
    push @jokerIds, $card->id;
  }

  # サンプルデッキ
  $class_name = 'deck_type';
  my $dtClass = MT->model($class_name);
  # トランプ全カード
  my $deck = $dtClass->get_by_key({ name => 'all cards' });
  $deck->cardtype_id($typeId);
  $deck->quantity($cardCount);
  $deck->setcount(1);
  $deck->save() or die $deck->errstr();
  # ジョーカー１枚
  $deck = $dtClass->get_by_key({ name => 'one joker' });
  $deck->cardtype_id($typeId);
  $deck->quantity($cardCount - 1);
  $deck->nouse($jokerIds[0]);
  $deck->setcount(1);
  $deck->save() or die $deck->errstr();
  # ジョーカーなし
  $deck = $dtClass->get_by_key({ name => 'no joker' });
  $deck->cardtype_id($typeId);
  $deck->quantity($cardCount - 2);
  $deck->nouse(join ',', @jokerIds);
  $deck->setcount(1);
  $deck->save() or die $deck->errstr();
  # ドローポーカー手札
  $deck = $dtClass->get_by_key({ name => 'draw poker' });
  $deck->cardtype_id($typeId);
  $deck->quantity(5);
  $deck->setcount(1);
  $deck->save() or die $deck->errstr();
};

1;