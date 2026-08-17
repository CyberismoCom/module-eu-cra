% base_projectCardType(Card, CardType) is the card type of a project card.
%
% Use this instead of field(Card, "cardType", CardType) whenever a rule reasons
% about a card in the project. Policy checks, denied operations, notifications,
% status indicators, calculated field values and transition side effects are all
% only ever consumed for project cards.
%
% field(Card, "cardType", _) also holds for every card inside every template, and
% the templates of an installed module set outnumber a project's own cards several
% times over. Binding through this predicate keeps template cards out of the
% grounding of every rule that starts from a card type.
%
% If a rule genuinely needs to reason about template cards, keep using the plain
% field/3 lookup there, or add templateCard(Card) explicitly.
base_projectCardType(Card, CardType) :-
    projectCard(Card),
    field(Card, "cardType", CardType).
