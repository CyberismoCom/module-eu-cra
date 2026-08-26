%
% Definitions for product structure diagrams
%
% Composition between products is recorded with links, never with parent and child
% cards, because a component can belong to more than one product. The diagram is
% therefore drawn entirely from the CSAF relationship links.

product(X) :- field(X, "cardType", "secdeva/cardTypes/product").

% attributes

title(X, Title) :- product(X), field(X, "title", Title).
origin(X, Origin) :- product(X), field(X, "secdeva/fieldTypes/productOrigin", Origin).
% Show the display name of the planned role rather than the stored enum value.
role(X, Display) :-
    product(X),
    field(X, "secdeva/fieldTypes/supplyChainRole", Role),
    field(("secdeva/fieldTypes/supplyChainRole", Role), "enumDisplayValue", Display).

% composition
%
% A CSAF link runs from the part to the whole. The diagram is drawn the other way
% round, from the whole to the part, so that a product appears above the things it
% is made of. contains(Whole, Part, Label) carries the label for that direction.

contains(Whole, Part, "contains by default") :-
    link(Part, Whole, "secdeva/linkTypes/defaultComponentOf").
contains(Whole, Part, "uses an external component") :-
    link(Part, Whole, "secdeva/linkTypes/externalComponentOf").
contains(Whole, Part, "contains optionally") :-
    link(Part, Whole, "secdeva/linkTypes/optionalComponentOf").
contains(Whole, Part, "installed alongside") :-
    link(Part, Whole, "secdeva/linkTypes/installedWith").
contains(Whole, Part, "platform for") :-
    link(Part, Whole, "secdeva/linkTypes/installedOn").

% transitive reach in both directions, used by the views to decide what to show

reaches(A, B) :- contains(A, B, _).
reaches(A, C) :- contains(A, B, _), reaches(B, C).

%
% Conversion to clingraph format
%

graph(toplevelGraph).

node(X, toplevelGraph) :- visible(X), product(X).

edge((A, B, Label), toplevelGraph) :-
    contains(A, B, Label),
    visible(A),
    visible(B).

title((A, B, Label), Label) :- edge((A, B, Label), _).

% labels

attr(node, X, label, @concatenate(
    "<<font point-size='30'><b> ", @wrap(Title), " </b></font><br/>>")) :-
        node(X, _), title(X, Title),
        not role(X, _).

attr(node, X, label, @concatenate(
    "<<font point-size='30'><b> ", @wrap(Title), " </b></font><br/>",
    "<font point-size='20'>[", Role, "]</font>>")) :-
        node(X, _), title(X, Title), role(X, Role).

attr(edge, (A, B, Label), label, @concatenate(
    "<<font point-size='22'> ", Label, " </font>>")) :- edge((A, B, Label), _).

% shapes: own products are drawn solid, third-party products dashed, so the
% boundary of what we manufacture is visible at a glance

attr(node, X, shape, rectangle) :- node(X, _).
attr(node, X, style, rounded) :- node(X, _), origin(X, "own").
attr(node, X, style, "rounded,dashed") :- node(X, _), not origin(X, "own").

% the product the diagram was opened from is drawn heavier
attr(node, X, penwidth, "5") :- node(X, _), focus(X).
attr(node, X, penwidth, "2") :- node(X, _), not focus(X).

attr(node, X, margin, "0.3") :- node(X, _).
attr(edge, (A, B, N), penwidth, "2") :- edge((A, B, N), _).
attr(edge, (A, B, N), arrowsize, "1.5") :- edge((A, B, N), _).

attr(node, X, href, @concatenate("/cards/", X)) :- node(X, _).

attr(graph, toplevelGraph, pad, "0.2").
attr(graph, toplevelGraph, nodesep, "1").
attr(graph, toplevelGraph, ranksep, "1.5").
attr(graph, G, fontname, "helvetica") :- graph(G).
attr(node, N, fontname, "helvetica") :- node(N, _).
attr(edge, (A, B, N), fontname, "helvetica") :- edge((A, B, N), _).
