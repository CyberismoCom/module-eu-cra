graph(toplevelGraph).

% drawableCard(X) means that X is a supported type of card in process diagrams.

% compliance requirement
drawableCard(Requirement) :- field(Requirement, "cardType", "ismsa/cardTypes/complianceRequirement").
node(Requirement, toplevelGraph) :-
    field(Requirement, "cardType", "ismsa/cardTypes/complianceRequirement"),
    visible(Requirement).

attr(node, Requirement, label, @concatenate("<<font point-size='32'> <b>", @wrap(Title), "</b> </font> <br/> <font point-size='19'>Compliance requirement</font>>")) :-
    field(Requirement, "cardType", "ismsa/cardTypes/complianceRequirement"),
    field(Requirement, "title", Title),
    visible(Requirement).

% task
drawableCard(Task) :- base_recurringTask(Task).
node(Task, toplevelGraph) :- base_recurringTask(Task), visible(Task).

attr(node, Task, label, @concatenate("<<font point-size='32'> <b>", @wrap(Title), "</b> </font> <br/> <font point-size='19'>Recurring task</font>>")) :-
    base_recurringTask(Task),
    field(Task, "title", Title),
    visible(Task).

% security requirement
drawableCard(Requirement) :- field(Requirement, "cardType", "secdeva/cardTypes/requirement").
node(Requirement, toplevelGraph) :- field(Requirement, "cardType", "secdeva/cardTypes/requirement"), visible(Requirement).

attr(node, Requirement, label, @concatenate("<<font point-size='32'> <b>", @wrap(Title), "</b> </font> <br/> <font point-size='19'>Security requirement</font>>")) :-
    field(Requirement, "cardType", "secdeva/cardTypes/requirement"),
    field(Requirement, "title", Title),
    visible(Requirement).

% evidence
drawableCard(Document) :- field(Document, "cardType", "base/cardTypes/controlledDocument").
drawableCard(Review) :- field(Review, "cardType", "base/cardTypes/review").
evidence(Evidence) :-
    base_recurringTask(Task),
    visible(Task),
    drawableCard(Evidence),
    link(Evidence, Task, "secdeva/linkTypes/evidences").

node(Evidence, toplevelGraph) :- evidence(Evidence).

attr(node, Evidence, label, @concatenate("<<font point-size='32'>", @wrap(Title), "</font> <br/> <font point-size='19'>", EvidenceLabel , "</font>>")) :-
    base_recurringTask(Task),
    visible(Task),
    link(Evidence, Task, "secdeva/linkTypes/evidences"),
    secdeva_evidence(TaskIdentifier, EvidenceIdentifier, EvidenceLabel),
    field(Task, "base/fieldTypes/identifier", TaskIdentifier),
    field(Evidence, "base/fieldTypes/identifier", EvidenceIdentifier),
    field(Evidence, "title", Title).

% evidence placeholder
evidencePlaceholder(@concatenate(Task, EvidenceIdentifier, EvidenceLabel)) :-
    base_recurringTask(Task),
    visible(Task),
    secdeva_evidence(TaskIdentifier, EvidenceIdentifier, EvidenceLabel),
    field(Task, "base/fieldTypes/identifier", TaskIdentifier),
    not field(Evidence, "base/fieldTypes/identifier", EvidenceIdentifier) :
    link(Evidence, Task, "secdeva/linkTypes/evidences").

node(Evidence, toplevelGraph) :- evidencePlaceholder(Evidence).

attr(node, @concatenate(Task, EvidenceIdentifier, EvidenceLabel), label, @concatenate("<<font point-size='32'>", @wrap(EvidenceLabel), "</font>>")) :-
    base_recurringTask(Task),
    visible(Task),
    secdeva_evidence(TaskIdentifier, EvidenceIdentifier, EvidenceLabel),
    field(Task, "base/fieldTypes/identifier", TaskIdentifier),
    not field(Evidence, "base/fieldTypes/identifier", EvidenceIdentifier) :
    link(Evidence, Task, "secdeva/linkTypes/evidences").

% "implements" relationship
edge((Task2, Task1, 1), toplevelGraph) :-
    link(Task1, Task2, "ismsa/linkTypes/implements"),
    visible(Task1),
    visible(Task2).
attr(edge, (Task2, Task1, 1), label, "<<font point-size='24'>Implemented by</font>>") :-
    link(Task1, Task2, "ismsa/linkTypes/implements"),
    visible(Task1),
    visible(Task2).

% "precedes" relationship
edge((Task1, Task2, 1), toplevelGraph) :-
    link(Task1, Task2, "secdeva/linkTypes/precedes"),
    visible(Task1),
    visible(Task2).
attr(edge, (Task1, Task2, 1), label, "<<font point-size='24'>Precedes</font>>") :-
    link(Task1, Task2, "secdeva/linkTypes/precedes"),
    visible(Task1),
    visible(Task2).

% "requires" relationship
edge((Task2, Task1, 1), toplevelGraph) :-
    link(Task1, Task2, "secdeva/linkTypes/requires"),
    visible(Task1),
    visible(Task2).
attr(edge, (Task2, Task1, 1), label, "<<font point-size='24'>Required by</font>>") :-
    link(Task1, Task2, "secdeva/linkTypes/requires"),
    visible(Task1),
    visible(Task2).

% "evidences" relationship
edge((Task, Evidence, 1), toplevelGraph) :-
    base_recurringTask(Task),
    visible(Task),
    link(Evidence, Task, "secdeva/linkTypes/evidences"),
    secdeva_evidence(TaskIdentifier, EvidenceIdentifier, _),
    field(Task, "base/fieldTypes/identifier", TaskIdentifier),
    field(Evidence, "base/fieldTypes/identifier", EvidenceIdentifier),
    field(Evidence, "title", Title).
attr(edge, (Task, Evidence, 1), label, "<<font point-size='24'>Evidenced by</font>>") :-
    base_recurringTask(Task),
    visible(Task),
    link(Evidence, Task, "secdeva/linkTypes/evidences"),
    secdeva_evidence(TaskIdentifier, EvidenceIdentifier, _),
    field(Task, "base/fieldTypes/identifier", TaskIdentifier),
    field(Evidence, "base/fieldTypes/identifier", EvidenceIdentifier).

% "evidences" relationship to evidence placeholders
edge((Task, @concatenate(Task, EvidenceIdentifier, EvidenceLabel), 1), toplevelGraph) :-
    base_recurringTask(Task),
    visible(Task),
    secdeva_evidence(TaskIdentifier, EvidenceIdentifier, EvidenceLabel),
    field(Task, "base/fieldTypes/identifier", TaskIdentifier),
    not field(Evidence, "base/fieldTypes/identifier", EvidenceIdentifier) :
    link(Evidence, Task, "secdeva/linkTypes/evidences").
attr(edge, (Task, @concatenate(Task, EvidenceIdentifier, EvidenceLabel), 1), label, "<<font point-size='24'>Evidenced by</font>>") :-
    base_recurringTask(Task),
    visible(Task),
    secdeva_evidence(TaskIdentifier, EvidenceIdentifier, EvidenceLabel),
    field(Task, "base/fieldTypes/identifier", TaskIdentifier),
    not field(Evidence, "base/fieldTypes/identifier", EvidenceIdentifier) :
    link(Evidence, Task, "secdeva/linkTypes/evidences").

% To make the links work with SVGs, add the href attribute for nodes
attr(node, X, href, @concatenate("/cards/", X)) :- node(X, _), not evidencePlaceholder(X).

% margins
attr(graph, toplevelGraph, pad, "0.2").
attr(graph, toplevelGraph, nodesep, "2").
attr(graph, toplevelGraph, ranksep, "3").
attr(node, X, margin, "0.4") :- node(X, _).
attr(graph, X, margin, "25") :- graph(X, _).

% penwidth
attr(graph, X, penwidth, "3") :- graph(X).
attr(graph, X, penwidth, "3") :- graph(X, _).
attr(node, X, penwidth, "3") :- node(X, _), not evidence(X).
attr(node, X, penwidth, "2") :- node(X, _), evidence(X).
attr(edge, (X, Y, N), pendwidth, "3") :- edge((X, Y, N), _).
attr(edge, (X, Y, N), arrowsize, "2") :- edge((X, Y, N), _).

% shapes of nodes
attr(node, X, shape, rectangle) :- node(X, _), field(X, "cardType", "ismsa/cardTypes/complianceRequirement").
attr(node, X, style, rounded) :- node(X, _), field(X, "cardType", "ismsa/cardTypes/complianceRequirement").
attr(node, X, shape, rectangle) :- node(X, _), base_recurringTask(X).
attr(node, X, style, rounded) :- node(X, _), base_recurringTask(X).
attr(node, X, shape, note) :- node(X, _), evidence(X).
attr(node, X, shape, note) :- node(X, _), field(X, "cardType", "secdeva/cardTypes/requirement").
attr(node, X, shape, note) :- node(X, _), evidencePlaceholder(X).
attr(node, X, style, dashed) :- node(X, _), evidencePlaceholder(X).

% fonts
attr(graph, G, fontname, "helvetica") :- graph(G).
attr(graph, G, fontname, "helvetica") :- graph(G, _).
attr(node, N, fontname, "helvetica") :- node(N, _).
attr(edge, (X, Y, N), fontname, "helvetica") :- edge((X, Y, N), _).

#show graph /1.
#show graph /2.
#show node /2.
#show edge /2.
#show attr /4.
