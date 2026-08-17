% Evidence takes its review period from the related control

fieldCalculated(Evidence, "base/fieldTypes/reviewPeriod", 365) :-
  base_projectCardType(Control, "ismsa/cardTypes/internalControl"),
  field(Control, "ismsa/fieldTypes/internalControlReviewPeriod", "12months"),
  link(Evidence, Control, "ismsa/linkTypes/evidences"),
  base_projectCardType(Evidence, EvidenceCardType),
  calculatedField(EvidenceCardType, "base/fieldTypes/reviewPeriod"),
  overridableField(EvidenceCardType, "base/fieldTypes/reviewPeriod").

fieldCalculated(Evidence, "base/fieldTypes/reviewPeriod", 180) :-
  base_projectCardType(Control, "ismsa/cardTypes/internalControl"),
  field(Control, "ismsa/fieldTypes/internalControlReviewPeriod", "6months"),
  link(Evidence, Control, "ismsa/linkTypes/evidences"),
  base_projectCardType(Evidence, EvidenceCardType),
  calculatedField(EvidenceCardType, "base/fieldTypes/reviewPeriod"),
  overridableField(EvidenceCardType, "base/fieldTypes/reviewPeriod").

fieldCalculated(Evidence, "base/fieldTypes/reviewPeriod", 90) :-
  base_projectCardType(Control, "ismsa/cardTypes/internalControl"),
  field(Control, "ismsa/fieldTypes/internalControlReviewPeriod", "3months"),
  link(Evidence, Control, "ismsa/linkTypes/evidences"),
  base_projectCardType(Evidence, EvidenceCardType),
  calculatedField(EvidenceCardType, "base/fieldTypes/reviewPeriod"),
  overridableField(EvidenceCardType, "base/fieldTypes/reviewPeriod").

fieldCalculated(Evidence, "base/fieldTypes/reviewPeriod", 30) :-
  base_projectCardType(Control, "ismsa/cardTypes/internalControl"),
  field(Control, "ismsa/fieldTypes/internalControlReviewPeriod", "1month"),
  link(Evidence, Control, "ismsa/linkTypes/evidences"),
  base_projectCardType(Evidence, EvidenceCardType),
  calculatedField(EvidenceCardType, "base/fieldTypes/reviewPeriod"),
  overridableField(EvidenceCardType, "base/fieldTypes/reviewPeriod").