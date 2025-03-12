secdeva_externalEntity(Card) :-
    field(Card, "cardType", "secdeva/cardTypes/external").

secdeva_externalEntity(Card) :-
    field(Card, "cardType", "secdeva/cardTypes/person").

field(Interface, "secdeva/fieldTypes/isExternal", "yes") :-
    field(Interface, "cardType", "secdeva/cardTypes/interface"),
    link(Source, Interface, "secdeva/linkTypes/dataflow", _),
    secdeva_externalEntity(Source).

field(Interface, "secdeva/fieldTypes/isExternal", "no") :-
    field(Interface, "cardType", "secdeva/cardTypes/interface"),
    not secdeva_externalEntity(Source) :
    link(Source, Interface, "secdeva/linkTypes/dataflow", _).

field(Interface, "secdeva/fieldTypes/isExternal", "noInfo") :-
    field(Interface, "cardType", "secdeva/cardTypes/interface"),
    not link(_, Interface, "secdeva/linkTypes/dataflow", _).

field(Interface, "secdeva/fieldTypes/crossesTrustBoundary", "noInfo") :-
    field(Interface, "cardType", "secdeva/cardTypes/interface"),
    not link(_, Interface, "secdeva/linkTypes/dataflow", _).


field(Interface, "secdeva/fieldTypes/crossesTrustBoundary", "yes") :-
    field(Interface, "cardType", "secdeva/cardTypes/interface"),
    link(Source, Interface, "secdeva/linkTypes/dataflow", _),
    field(TrustBoundary, "cardType", "secdeva/cardTypes/trustBoundary"),
    ancestor(Interface, TrustBoundary),
    not ancestor(Source, TrustBoundary).

field(Interface, "secdeva/fieldTypes/crossesTrustBoundary", "no") :-
    field(Interface, "cardType", "secdeva/cardTypes/interface"),
    link(_, Interface, "secdeva/linkTypes/dataflow", _),
    ancestor(Source, TrustBoundary) :
    link(Source, Interface, "secdeva/linkTypes/dataflow", _),
    field(TrustBoundary, "cardType", "secdeva/cardTypes/trustBoundary"),
    ancestor(Interface, TrustBoundary).
