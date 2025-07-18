% secdeva_defaultTitlePrefix(Identifier, Prefix) defines the beginning of the title
% when creating a card with a certain base/fieldTypes/identifier.
% The title is formed by appending the name of the project to the prefix
secdeva_defaultTitlePrefix("eucra_review_attack-surface", "Attack surface analysis for ").
secdeva_defaultTitlePrefix("eucra_document_attack-surface", "Attack surface specification for ").
secdeva_defaultTitlePrefix("eucra_test_penetration", "Penentration test for ").
secdeva_defaultTitlePrefix("eucra_review_privacy-by-design", "Privacy by design review of ").
secdeva_defaultTitlePrefix("eucra_review_product-documentation", "Product documentation review of ").
secdeva_defaultTitlePrefix("eucra_review_integrity-protection-of-release", "Review of release integrity protection - ").
secdeva_defaultTitlePrefix("eucra_review_security-design", "Security design review for ").
secdeva_defaultTitlePrefix("eucra_document_support-period", "Support period document for ").
secdeva_defaultTitlePrefix("eucra_review_technical-documentation", "Technical documentation review for ").
secdeva_defaultTitlePrefix("eucra_review_distributed-products", "Review of distributed products for ").
secdeva_defaultTitlePrefix("eucra_review_imported-products", "Review of imported products for ").

% The default title for security advisory includes today's date:
onTransitionSetField(
    Card,
    "Create",
    Card,
    "title", @concatenate(@today, " Security advisory - ", ProjectName)) :-
    field(Card, "base/fieldTypes/identifier", "eucra_document_security-advisory"),
    secdeva_closestProject(Card, Project),
    field(Project, "title", ProjectName).