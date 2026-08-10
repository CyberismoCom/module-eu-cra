% secdeva_defaultTitle(Identifier, Prefix) defines the beginning of the title
% when creating a card with a certain base/fieldTypes/identifier.
% The title is formed by appending the name of the project to the prefix

% These facts have been kept for compatibility with legacy content:
secdeva_defaultTitle("eucra_review_attack-surface", "Attack surface analysis for ").
secdeva_defaultTitle("eucra_document_attack-surface", "Attack surface specification for ").
secdeva_defaultTitle("eucra_test_penetration", "Penentration test for ").
secdeva_defaultTitle("eucra_review_privacy-by-design", "Privacy by design review of ").
secdeva_defaultTitle("eucra_review_product-documentation", "Product documentation review of ").
secdeva_defaultTitle("eucra_review_integrity-protection-of-release", "Review of release integrity protection - ").
secdeva_defaultTitle("eucra_review_security-design", "Security design review for ").

% Default titles for EU CRA content:
secdeva_defaultTitle("eucra_document_support-period", "Support period document - ").
secdeva_defaultTitleWithDate("eucra_review_technical-documentation", "Review of technical documentation - ").
secdeva_defaultTitleWithDate("eucra_review_distributed-products", "Review of distributed products - ").
secdeva_defaultTitleWithDate("eucra_review_imported-products", "Review of imported products - ").

% The default title for security advisory includes today's date:
onTransitionSetField(
    Card,
    "Create",
    Card,
    "title", @concatenate(@today, " Security advisory - ", ProjectName)) :-
    field(Card, "base/fieldTypes/identifier", "eucra_document_security-advisory"),
    secdeva_closestProject(Card, Project),
    field(Project, "title", ProjectName).