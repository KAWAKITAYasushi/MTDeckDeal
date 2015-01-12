package DeckDeal::Tags;

use strict;
use List::Util qw( shuffle );

sub hdlr_decks {
  my ($ctx, $args, $cond) = @_;

  my $blog = $ctx->stash('blog') || 0;

  my $deck_type = MT->model('deck_type');
  my $deck = $deck_type->load($args);
  my @nouse = split ',', $deck->nouse();
  my @must = split ',', $deck->must();

  my $card = MT->model('card');
  my @deckCards;

  if (@must) {
    my $iter = $card->load_iter(@must);
    while (my $card = $iter->()) {
      push (@deckCards, $card->id);
    }
  }
  my $iter = $card->load_iter();
  while (my $card = $iter->()) {
    last if @deckCards == $deck->quantity();
    next if grep { $card->id() eq $_ } @nouse;
    next if grep { $card->id() eq $_ } @deckCards;
    push (@deckCards, $card->id());
  }
  @deckCards = shuffle @deckCards;

  my $out;
  for my $card (@deckCards) {
    local $ctx->{__stash}{card} = $card;

    my $tokens = $ctx->stash('tokens');
    my $builder = $ctx->stash('builder');

    $out .= $builder->build( $ctx, $tokens, $cond)
          || return $ctx->error( $builder->errstr );
  }

  return $out;
}

sub hdlr_deck_card {
  my ($ctx, $args) = @_;

  my $id = $ctx->stash('card') || $args->id;
  my $class = MT::model->('card');
  my $card;
  if ($id) {
    $card = $class->load($id);
  } else {
    $card = $class->load($args);
  }
  my $out = '<span class="' . $card->type . '_' . $card->value . '">' . $card->label . '</span>';
  return $out;
}

1;