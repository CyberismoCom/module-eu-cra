% ismsa_riskLevel(Impact, Likelihood, RiskLevel)
ismsa_riskLevel("veryLow", "veryLow", "veryLow").
ismsa_riskLevel("veryLow", "low", "veryLow").
ismsa_riskLevel("veryLow", "moderate", "low").
ismsa_riskLevel("veryLow", "high", "low").
ismsa_riskLevel("veryLow", "veryHigh", "moderate").
ismsa_riskLevel("low", "veryLow", "veryLow").
ismsa_riskLevel("low", "low", "low").
ismsa_riskLevel("low", "moderate", "moderate").
ismsa_riskLevel("low", "high", "moderate").
ismsa_riskLevel("low", "veryHigh", "moderate").
ismsa_riskLevel("moderate", "veryLow", "low").
ismsa_riskLevel("moderate", "low", "moderate").
ismsa_riskLevel("moderate", "moderate", "moderate").
ismsa_riskLevel("moderate", "high", "high").
ismsa_riskLevel("moderate", "veryHigh", "high").
ismsa_riskLevel("high", "veryLow", "low").
ismsa_riskLevel("high", "low", "moderate").
ismsa_riskLevel("high", "moderate", "high").
ismsa_riskLevel("high", "high", "high").
ismsa_riskLevel("high", "veryHigh", "veryHigh").
ismsa_riskLevel("veryHigh", "veryLow", "moderate").
ismsa_riskLevel("veryHigh", "low", "moderate").
ismsa_riskLevel("veryHigh", "moderate", "high").
ismsa_riskLevel("veryHigh", "high", "veryHigh").
ismsa_riskLevel("veryHigh", "veryHigh", "veryHigh").

field(Risk, "ismsa/fieldTypes/riskInitialRisk", InitialRisk) :-
    field(Risk, "ismsa/fieldTypes/riskInitialLikelihood", InitialLikelihood),
    field(Risk, "ismsa/fieldTypes/riskInitialImpact", InitialImpact),
    ismsa_riskLevel(InitialImpact, InitialLikelihood, InitialRisk).

field(Risk, "ismsa/fieldTypes/riskResidualRisk", ResidualRisk) :-
    field(Risk, "ismsa/fieldTypes/riskResidualLikelihood", ResidualLikelihood),
    field(Risk, "ismsa/fieldTypes/riskResidualImpact", ResidualImpact),
    ismsa_riskLevel(ResidualImpact, ResidualLikelihood, ResidualRisk).

