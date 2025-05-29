graph(toplevelGraph).
attr(graph, toplevelGraph, rankdir, "LR").

node(X, toplevelGraph) :- ismsa_asset(X, _), visible(X).
node(X, toplevelGraph) :- field(X, "cardType", "ismsa/cardTypes/risk"), visible(X).
node(X, toplevelGraph) :- field(X, "cardType", "ismsa/cardTypes/control"), visible(X).
node(X, toplevelGraph) :- field(X, "cardType", "secdeva/cardTypes/requirement"), visible(X).
node(X, toplevelGraph) :- base_recurringTask(X), visible(X).

attr(node, X, label, @concatenate("<<font point-size='32'> <b>", @wrap(Title), "</b> </font> <br/> <font point-size='19'>", Type, "</font>>")) :-
    ismsa_asset(X, Type),
    field(X, "title", Title),
    visible(X).

attr(node, X, label, @concatenate("<<font point-size='32'> <b>", @wrap(Title), "</b> </font> <br/><font point-size='19'>Risk</font>>")) :-
    field(X, "cardType", "ismsa/cardTypes/risk"),
    field(X, "title", Title),
    visible(X).

attr(node, X, label, @concatenate("<<font point-size='32'> <b>", @wrap(Title), "</b> </font> <br/><font point-size='19'>Control</font>>")) :-
    field(X, "cardType", "ismsa/cardTypes/control"),
    field(X, "title", Title),
    visible(X).

attr(node, X, label, @concatenate("<<font point-size='32'> <b>", @wrap(Title), "</b> </font> <br/><font point-size='19'>Requirement</font>>")) :-
    field(X, "cardType", "secdeva/cardTypes/requirement"),
    field(X, "title", Title),
    visible(X).

attr(node, X, label, @concatenate("<<font point-size='32'> <b>", @wrap(Title), "</b> </font> <br/><font point-size='19'>Recurring task</font>>")) :-
    base_recurringTask(X),
    field(X, "title", Title),
    visible(X).

edge((Asset, Risk, 1), toplevelGraph) :-
    link(Asset, Risk, "ismsa/linkTypes/presentsRisk"),
    visible(Asset),
    visible(Risk).
attr(edge, (Asset, Risk, 1), label, "<<font point-size='24'>Presents risk</font>>") :-
    link(Asset, Risk, "ismsa/linkTypes/presentsRisk"),
    visible(Asset),
    visible(Risk).

edge((Risk, Control, 1), toplevelGraph) :-
    link(Control, Risk, "ismsa/linkTypes/mitigates"),
    visible(Control),
    visible(Risk).
attr(edge, (Risk, Control, 1), label, "<<font point-size='24'>Mitigated by</font>>") :-
    link(Control, Risk, "ismsa/linkTypes/mitigates"),
    visible(Control),
    visible(Risk).

% To make the links work with SVGs, add the href attribute for nodes
attr(node, X, href, @concatenate("/cards/", X)) :- node(X, _).

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

% shapes of nodes
attr(node, X, shape, rectangle) :- node(X, _), not invisible(X).
attr(node, X, style, rounded) :- node(X, _), not invisible(X).

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
