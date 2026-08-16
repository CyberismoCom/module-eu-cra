% Evidence takes its review period from the related control

fieldCalculated(Evidence, "base/fieldTypes/reviewPeriod", 365) :-
  field(Control, "cardType", "ismsa/cardTypes/internalControl"),
  field(Control, "ismsa/fieldTypes/internalControlReviewPeriod", "12months"),
  link(Evidence, Control, "ismsa/linkTypes/evidences"),
  field(Evidence, "cardType", EvidenceCardType),
  calculatedField(EvidenceCardType, "base/fieldTypes/reviewPeriod"),
  overridableField(EvidenceCardType, "base/fieldTypes/reviewPeriod").

fieldCalculated(Evidence, "base/fieldTypes/reviewPeriod", 180) :-
  field(Control, "cardType", "ismsa/cardTypes/internalControl"),
  field(Control, "ismsa/fieldTypes/internalControlReviewPeriod", "6months"),
  link(Evidence, Control, "ismsa/linkTypes/evidences"),
  field(Evidence, "cardType", EvidenceCardType),
  calculatedField(EvidenceCardType, "base/fieldTypes/reviewPeriod"),
  overridableField(EvidenceCardType, "base/fieldTypes/reviewPeriod").

fieldCalculated(Evidence, "base/fieldTypes/reviewPeriod", 90) :-
  field(Control, "cardType", "ismsa/cardTypes/internalControl"),
  field(Control, "ismsa/fieldTypes/internalControlReviewPeriod", "3months"),
  link(Evidence, Control, "ismsa/linkTypes/evidences"),
  field(Evidence, "cardType", EvidenceCardType),
  calculatedField(EvidenceCardType, "base/fieldTypes/reviewPeriod"),
  overridableField(EvidenceCardType, "base/fieldTypes/reviewPeriod").

fieldCalculated(Evidence, "base/fieldTypes/reviewPeriod", 30) :-
  field(Control, "cardType", "ismsa/cardTypes/internalControl"),
  field(Control, "ismsa/fieldTypes/internalControlReviewPeriod", "1month"),
  link(Evidence, Control, "ismsa/linkTypes/evidences"),
  field(Evidence, "cardType", EvidenceCardType),
  calculatedField(EvidenceCardType, "base/fieldTypes/reviewPeriod"),
  overridableField(EvidenceCardType, "base/fieldTypes/reviewPeriod").