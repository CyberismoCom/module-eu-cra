%
% Definitions for architecture modeling
%

% process
process(X) :- field(X, "cardType", "secdeva/cardTypes/process").
entity(X) :- process(X).

% external
external(X) :- field(X, "cardType", "secdeva/cardTypes/external").
entity(X) :- external(X).

% trust boundary
trustBoundary(X) :- field(X, "cardType", "secdeva/cardTypes/trustBoundary").
entity(X) :- trustBoundary(X).

% person
person(X) :- field(X, "cardType", "secdeva/cardTypes/person").
external(X) :- person(X).

% datastore
datastore(X) :- field(X, "cardType", "secdeva/cardTypes/dataStore").
entity(X) :- datastore(X).

% interfaces (always hidden)
interface(X) :- field(X, "cardType", "secdeva/cardTypes/interface").
entity(X) :- interface(X).
hide(X) :- interface(X).

% attributes of entities
title(X, Title) :- entity(X), field(X, "title", Title).
description(X, Description) :- entity(X), field(X, "secdeva/fieldTypes/description", Description).
technology(X, Technology) :- entity(X), field(X, "secdeva/fieldTypes/technology", Technology).

% recursive composition rules
% we use consistsOf and contains instead of parent and ancestor, because
% composition may be indicated either by ancestorship or by links
consistsOf(Y, X) :- parent(X, Y), entity(X), entity(Y).
contains(X, Y) :- consistsOf(X, Y), entity(X), entity(Y).
contains(X, Z) :- consistsOf(X, Y), contains(Y, Z), entity(X), entity(Y), entity(Z).
entityLevel(X, 1) :- entity(X), not consistsOf(_, X).
entityLevel(X, N+1) :- entity(X), consistsOf(Y, X), entityLevel(Y, N).

% dataflows

dataflow(A, B, Title) :- link(A, B, "secdeva/linkTypes/dataflow", Title).

%
% Conversion from the architecture model to clingraph format
%

% view definitions

% the user may want to hide an entity.
% when an entity is hidden, its composite entities will also be hidden.
% hiding takes precedence over viewing:
% if the user wants to both view and hide an entity, the entity will not be shown

hide(Y) :- entity(X), hide(X), consistsOf(X, Y).

% the user may define viewAll to mean that all entities should be shown
% directlyVisible(X) means that entity X is visible because the user says so, based on the view definitions
% visible(X) means that entity X will be shown in the diagram
directlyVisible(X) :- entity(X), viewAll, not hide(X).
visible(X) :- directlyVisible(X), not hide(X).

% the user may define view(X) to mean that entity X and all its composite entities should be visible
directlyVisible(X) :- entity(X), view(X), not hide(X).
view(Y) :- entity(X), view(X), consistsOf(X, Y), not hide(Y).

% the user may define view(X, N) to mean that entity X and its composite entities are visible on N composite levels
view(Y, N - 1) :- entity(X), view(X, N), N > 1, consistsOf(X, Y), not hide(Y).
directlyVisible(X) :- entity(X), view(X, N), N > 0, not hide(X).

% the user may define viewAll(N) to mean that all entities should be shown
% with N levels of detail

view(X, N) :- entity(X), entityLevel(X, 1), viewAll(N), not hide(X).

% graphs

% top level graph is for top level entities and enties whose parent is not visible
graph(toplevelGraph).

% if a visible entity has visible children, then it is a graph.
% let's also create an invisible point node to act as an endpoint of any edges of each graph.
% the invisible point is only needed if the graph rather than one of its nodes is an endpoint of a dataflow.
% this is a workaround, as it seems hard to get Graphviz draw edges to clusters properly.
% invisible(X) means that X is such an invisible point inside a graph.

% graphTopLevelEntity(X) means that X is a top-level entity that must be drawn as a graph,
% because it has visible "children"
graphTopLevelEntity(X) :- entity(X), visible(X), entityLevel(X, 1), visible(Y), consistsOf(X, Y).
graph(X, toplevelGraph) :- graphTopLevelEntity(X).
node(X, X) :- graphTopLevelEntity(X).
invisible(X) :- graphTopLevelEntity(X).
attr(node, X, shape, point) :- graphTopLevelEntity(X).
attr(node, X, style, invis) :- graphTopLevelEntity(X).

% graphEntityHiddenAncestors(X) means that X is an entity that must be drawn as a graph in the toplevelGraph,
% because it has visible "children", and its own parent is not visible
graphEntityHiddenAncestors(X) :-  visible(X), not visible(P), consistsOf(P, X), entity(X), visible(Y), consistsOf(X, Y).
graph(X, toplevelGraph) :- graphEntityHiddenAncestors(X).
node(X, X) :- graphEntityHiddenAncestors(X).
invisible(X) :- graphEntityHiddenAncestors(X).
attr(node, X, shape, point) :- graphEntityHiddenAncestors(X).
attr(node, X, style, invis) :- graphEntityHiddenAncestors(X).

% graphLowerLevel(X, P) means that X has visible children and a visible parent,
% so it must be drawn as a subgraph of P
graphLowerLevel(X, P) :- visible(X), entity(X), visible(P), consistsOf(P, X), visible(Y), consistsOf(X, Y).
graph(X, P) :- graphLowerLevel(X, P).
node(X, X) :- graphLowerLevel(X, P).
invisible(X) :- graphLowerLevel(X, P).
attr(node, X, shape, point) :- graphLowerLevel(X, P).
attr(node, X, style, invis) :- graphLowerLevel(X, P).

% nodes

% if an entity is visible, but it's not a graph (= does not have visible children), then it is a node
node(X, toplevelGraph) :- entity(X), visible(X), entityLevel(X, 1), not graph(X, toplevelGraph).
node(X, Y) :- entity(X), visible(X), consistsOf(Y, X), not graph(X, _), visible(Y).
node(X, toplevelGraph) :- entity(X), visible(X), consistsOf(Y, X), not graph(X, _), not visible(Y).

% edges and representatives of entities when drawing dataflows

% visible(dataflow(X, Y, N)) means that the dataflow with identifier N from X to Y is visible
% a dataflow from X to Y should visible, if it is an "external" dataflow
% of a directly visible entity Z, which is either X, Y or an ancestor of X or Y.
% Here X or Y must not be an ancestor of the other.
% By an external dataflow, we mean a dataflow whose other endpoint is outside Z
visible(dataflow(X, Y, N)) :- dataflow(X, Y, N), directlyVisible(X), entity(X), entity(Y), not contains(X, Y), not contains(Y, X), not hide(Y).
visible(dataflow(X, Y, N)) :- dataflow(X, Y, N), directlyVisible(Y), entity(X), entity(Y), not contains(Y, X), not contains(X, Y), not hide(X).

visible(dataflow(X, Y, N)) :- dataflow(X, Y, N), directlyVisible(Z), entity(Z), contains(Z, X), entity(X), entity(Y), not contains(Z, Y), not contains(X, Y), not contains(Y, X), not hide(Y).
visible(dataflow(X, Y, N)) :- dataflow(X, Y, N), directlyVisible(Z), entity(Z), contains(Z, X), entity(X), entity(Y), not contains(Z, Y), not contains(X, Y), not contains(Y, X), not hide(Z).

visible(dataflow(X, Y, N)) :- dataflow(X, Y, N), directlyVisible(Z), entity(Z), contains(Z, Y), entity(X), entity(Y), not contains(Z, X), not contains(X, Y), not contains(Y, X), not hide(X).
visible(dataflow(X, Y, N)) :- dataflow(X, Y, N), directlyVisible(Z), entity(Z), contains(Z, Y), entity(X), entity(Y), not contains(Z, X), not contains(X, Y), not contains(Y, X), not hide(Z).

% for clarity, we make dataflows between visible entities visible
visible(dataflow(X, Y, N)) :- dataflow(X, Y, N), visible(X), entity(X), visible(Y), entity(Y), not contains(X, Y), not contains(Y, X), not hide(X), not hide(Y).

% representative(X, Y) means that entity X will represent entity Y when drawing dataflows
% the existence of a representative doesn't imply anything about visibility of dataflows

% if there exists a visible dataflow, then the representatives of the endpoints must be visible
visible(RX) :- visible(dataflow(X, Y, _)), representative(RX, X), not hide(RX).
visible(RY) :- visible(dataflow(X, Y, _)), representative(RY, Y), not hide(RY).

% if an entity is visible, then it will be its own representative
representative(X, X) :- entity(X), visible(X), not hide(X).

% the composite entities of a node won't be visible, so the node will represent its composite entities
% we must exclude invisible nodes, which are not really nodes in the graph
representative(Z, X) :- entity(Z), visible(Z), entity(X), contains(Z, X), node(Z, _), not invisible(Z), not hide(Z).

% all top-level entities represent themselves
representative(X, X) :- entity(X), entityLevel(X, 1).

% highestLevelNonCommonAncestor(X, Y, Z) means that entity Z is
% the highest level ancestor of X that is not an ancestor of Y
highestLevelNonCommonAncestor(X, Y, Z) :-
    entity(X),
    entity(Y),
    contains(Z, X),
    not contains(Z, Y),
    entityLevel(Z, ZN),
    ZN = #min {N : contains(Q, X), not contains(Q, Y), entityLevel(Q, N)}.

% the following clauses make the highest level non-common ancestors of dataflow endpoints visible
% if there is no such ancestor, then the endpiont itself is made visible

visible(Z) :-
    visible(dataflow(X, Y, _)),
    highestLevelNonCommonAncestor(Y, X, Z),
    not hide(Z).

visible(Z) :-
    visible(dataflow(Y, X, _)),
    highestLevelNonCommonAncestor(Y, X, Z),
    not hide(Z).

visible(Y) :-
    visible(dataflow(X, Y, _)),
    not highestLevelNonCommonAncestor(Y, X, _),
    not hide(Y).

visible(Y) :-
    visible(dataflow(Y, X, _)),
    not highestLevelNonCommonAncestor(Y, X, _),
    not hide(Y).

% edges are drawn between the representative entities of the endpoints of each dataflow
% edge_ is a helper predicate to keep track of both the original entities and the representatives of the dataflow
% the edge is placed on the toplevel graph

edge_((XR, YR, N), toplevelGraph, X, Y) :-
    representative(XR, X),
    representative(YR, Y),
    visible(dataflow(X, Y, N)),
    consistsOf(GX, XR),
    consistsOf(GY, YR),
    XR != YR.

edge_((XR, YR, N), toplevelGraph, X, Y) :-
    representative(XR, X),
    representative(YR, Y),
    visible(dataflow(X, Y, N)),
    node(XR, toplevelGraph),
    XR != YR.

edge_((XR, YR, N), toplevelGraph, X, Y) :-
    representative(XR, X),
    representative(YR, Y),
    visible(dataflow(X, Y, N)),
    node(YR, toplevelGraph),
    XR != YR.

edge((XR, YR, N), G) :- edge_((XR, YR, N), G, _, _).

% edges that have a graph as an endpoint
attr(graph, X, compound, true) :- graph(X).
attr(graph, X, compound, true) :- graph(X, _).

attr(edge, (XR, YR, N), ltail, @concatenate("cluster_", XR)) :- edge((XR, YR, N), _), graph(XR, _).
attr(edge, (XR, YR, N), lhead, @concatenate("cluster_", YR)) :- edge((XR, YR, N), _), graph(YR, _).

% edge "inherits" title from the original dataflow
title((XR, YR, Title), Title) :- dataflow(X, Y, Title), edge_((XR, YR, Title), _, X, Y).

% margins
attr(graph, toplevelGraph, pad, "0.2").
attr(graph, toplevelGraph, nodesep, "2").
attr(graph, toplevelGraph, ranksep, "3").
attr(node, X, margin, "0.4") :- node(X, _).
attr(graph, X, margin, "25") :- graph(X, _).

% penwidth
attr(graph, X, penwidth, "3") :- graph(X).
attr(graph, X, penwidth, "3") :- graph(X, _).
attr(node, X, penwidth, "3") :- node(X, _).
attr(edge, (X, Y, N), pendwidth, "3") :- edge((X, Y, N), _).
attr(edge, (X, Y, N), arrowsize, "2") :- edge((X, Y, N), _).

% node labels and descriptions

kind(X, "Person") :- person(X).
kind(X, "External") :- external(X), not person(X).
kind(X, "Process") :- process(X).
kind(X, "Trust Boundary") :- trustBoundary(X).
kind(X, "Datastore") :- datastore(X).

attr(node, X, label, @concatenate(
    "<<font point-size='32'><b> ", @wrap(Title)," </b></font><br/>",
    "<font point-size='19'>[", Kind, "]</font> <br/>>")) :-
        not description(X, _),
        not technology(X, _),
        title(X, Title),
        kind(X, Kind),
        entity(X),
        node(X, G),
        not invisible(X).

attr(node, X, label, @concatenate(
    "<<font point-size='32'> <b> ", @wrap(Title)," </b> </font> <br/>",
    "<font point-size='19'>[", Kind,"]</font> <br/>",
    "<font point-size='22'>", @wrap(Description), "</font>>")) :-
        description(X, Description),
        not technology(X, _),
        title(X, Title),
        kind(X, Kind),
        entity(X),
        node(X, G),
        not invisible(X).

attr(node, X, label, @concatenate(
    "<<font point-size='32'><b> ", @wrap(Title)," </b></font><br/>",
    "<font point-size='19'>[", Kind,": ", @wrap(Technology), "]</font>>")) :-
        not description(X, _),
        technology(X, Technology),
        title(X, Title),
        kind(X, Kind),
        entity(X),
        node(X, G),
        not invisible(X).

attr(node, X, label, @concatenate(
    "<<font point-size='32'><b> ", @wrap(Title)," </b></font><br/>",
    "<font point-size='19'>[", Kind,": ", @wrap(Technology), "]</font><br/>",
    "<font point-size='22'>", @wrap(Description), "</font>>")) :-
        description(X, Description),
        technology(X, Technology),
        title(X, Title),
        kind(X, Kind),
        entity(X),
        node(X, G),
        not invisible(X).

% To make the links work with SVGs, add the href attribute for nodes
attr(node, X, href, @concatenate("/cards/", X)) :- node(X, _), not invisible(X).

% graph labels and descriptions

attr(graph, X, label, @concatenate(
    "<<font point-size='24'><b> ", @wrap(Title), " </b></font><br/>",
    "<font point-size='19'>[", Kind, "]</font><br/>>")) :-
        not description(X, _),
        not technology(X, _),
        title(X, Title),
        kind(X, Kind),
        entity(X),
        graph(X, _).

attr(graph, X, label, @concatenate(
    "<<font point-size='24'><b> ", @wrap(Title), " </b></font><br/>",
    "<font point-size='19'>[", Kind, "]</font><br/>",
    "<font point-size='22'>", @wrap(Description), "</font>>")) :-
        description(X, Description),
        not technology(X, _),
        title(X, Title),
        kind(X, Kind),
        entity(X),
        graph(X, _).

attr(graph, X, label, @concatenate(
    "<<font point-size='24'><b> ", @wrap(Title), " </b></font><br/>",
    "<font point-size='19'>[", Kind, ": ", @wrap(Technology), "]</font>>")) :-
        not description(X, _),
        technology(X, Technology),
        title(X, Title),
        kind(X, Kind),
        entity(X),
        graph(X, _).

attr(graph, X, label, @concatenate(
    "<<font point-size='24'><b> ", @wrap(Title), " </b></font><br/>",
    "<font point-size='19'>[", Kind, ": ", @wrap(Technology), "]</font><br/>",
    "<font point-size='22'>", @wrap(Description), "</font>>")) :-
        description(X, Description),
        technology(X, Technology),
        title(X, Title),
        kind(X, Kind),
        entity(X),
        graph(X, _).

attr(graph, X, labelloc, b) :- entity(X), graph(X, _).
attr(graph, X, labeljust, l) :- entity(X), graph(X, _).

% edge labels. Edges cannot have technology descriptions
% notice the extra spaces, as for compatibility reasons, we have to use at least a whitespace the label
attr(edge, (X, Y, Title), label, @concatenate(
    "<<font point-size='24'> ", Title, " </font>>")) :-
        edge((X, Y, Title), _).

% shapes of graphs
attr(graph, X, shape, rectangle) :- process(X), graph(X, _).
attr(graph, X, style, rounded) :- process(X), graph(X, _).

attr(graph, X, shape, rectangle) :- external(X), graph(X, _).
attr(graph, X, shape, cylinder) :- datastore(X), graph(X, _).

attr(graph, X, shape, rectangle) :- trustBoundary(X), graph(X, _).
attr(graph, X, style, dashed) :- trustBoundary(X), graph(X, _).
attr(graph, X, color, "#aa0000") :- trustBoundary(X), graph(X, _).
attr(graph, X, color, "#000000") :- not trustBoundary(X), graph(X, _).

% shapes of nodes
attr(node, X, shape, rectangle) :- process(X), node(X, _), not invisible(X).
attr(node, X, style, rounded) :- process(X), node(X, _), not invisible(X).

attr(node, X, shape, rectangle) :- trustBoundary(X), node(X, _), not invisible(X).
attr(node, X, style, dashed) :- trustBoundary(X), node(X, _), not invisible(X).
attr(node, X, color, "#aa0000") :- trustBoundary(X), node(X, _), not invisible(X).
attr(node, X, color, "#000000") :- not trustBoundary(X), node(X, _), not invisible(X).

attr(node, X, shape, rectangle) :- external(X), node(X, _), not invisible(X).
attr(node, X, shape, cylinder) :- datastore(X), node(X, _), not invisible(X).

% fonts
attr(graph, G, fontname, "helvetica") :- graph(G).
attr(graph, G, fontname, "helvetica") :- graph(G, _).
attr(node, N, fontname, "helvetica") :- node(N, _), not invisible(N).
attr(edge, (X, Y, N), fontname, "helvetica") :- edge((X, Y, N), _).

#show graph /1.
#show graph /2.
#show node /2.
#show edge /2.
#show attr /4.
