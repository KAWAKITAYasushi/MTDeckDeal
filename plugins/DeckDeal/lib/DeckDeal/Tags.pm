package DeckDeal::Tags;

use strict;
use List::Util qw( shuffle );
use YAML;

sub hdlr_decks {
  my ($ctx, $args, $cond) = @_;

  my $blog = $ctx->stash('blog') || 0;
  my $terms = {};
  if ($args->{name}) {
    $terms->{name} = $args->{name};
  } elsif ($args->{id}) {
    $terms = $args->{id};
  }

  my $deck_type = MT->model('deck_type');
  my $deck = $deck_type->load($terms);
  my @nouse = split ',', $deck->nouse();
  my @must = split ',', $deck->must();

  my $card = MT->model('card');
  my @deckCards;

  if (@must) {
    my $iter = $card->load_iter(\@must);
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
  my $cnt = 0;
  my $tokens = $ctx->stash('tokens');
  my $builder = $ctx->stash('builder');
  for my $card (@deckCards) {
    local $ctx->{__stash}{vars}{__first__} = 1 unless $cnt;
    local $ctx->{__stash}{vars}{__last__} = 1 if $cnt == $#deckCards;
    local $ctx->{__stash}{vars}{__counter__} = ++$cnt;
    local $ctx->{__stash}{vars}{__even__} = 1 unless $cnt % 2;
    local $ctx->{__stash}{vars}{__odd__} = 1 if $cnt % 2;
    local $ctx->{__stash}{vars}{_card_id_} = $card;
    $ctx->stash( 'card', $card );

    $out .= $builder->build( $ctx, $tokens, $cond)
          || return $ctx->error( $builder->errstr );
  }

  return $out;
}

sub hdlr_deck_card {
  my ($ctx, $args) = @_;

  my $id = $ctx->stash('card') || $args->id;
  my $terms = {};
  doLog(__LINE__ . YAML::Dump($args), 'DeckDeal::Tags');
  if ($args->{name}) {
    $terms->{name} = $args->{name};
  } elsif ($id) {
    $terms = $id;
  }
  doLog(__LINE__ . YAML::Dump($terms), 'DeckDeal::Tags');
  my $out = '' . YAML::Dump($terms);
  my $class = MT::model->('card');
  if ($terms) {
    my $card = $class->load($terms);
    $out = '<span class="' . $card->type . '_' . $card->value . '">' . $card->label . '</span>';
  }
  return $out;
}

sub doLog {
  my ($msg, $class) = @_;
  return unless defined($msg);

  require MT::Log;
  my $log = new MT::Log;
  $log->message($msg);
  $log->level(MT::Log::DEBUG());
  $log->class($class) if $class;
  $log->save or die $log->errstr;
}

1;
