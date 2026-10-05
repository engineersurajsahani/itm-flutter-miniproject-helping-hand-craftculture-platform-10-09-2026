import 'product_model.dart';

/// ============================================================================
/// VIVA EXPLANATION HEADER
/// CONCEPT: Practical 14 & 15 - Data Modeling & Object State
/// LOGIC  : Defines Craft Job Opportunity postings, required skills, stipend,
///          and application tracking state.
/// VIVA TIP: What is the purpose of enum state fields like JobStatus?
///          - Guarantees type-safety and prevents invalid state strings.
/// ============================================================================

enum JobStatus { open, filled, inReview }

class CraftJob {
  final String id;
  final String title;
  final String organizationOrBuyer;
  final String location;
  final CraftCategory requiredCraft;
  final double stipendOrBudget;
  final String duration;
  final String description;
  final JobStatus status;
  final List<String> applicantNames;

  CraftJob({
    required this.id,
    required this.title,
    required this.organizationOrBuyer,
    required this.location,
    required this.requiredCraft,
    required this.stipendOrBudget,
    required this.duration,
    required this.description,
    this.status = JobStatus.open,
    this.applicantNames = const [],
  });

  CraftJob copyWith({
    List<String>? applicantNames,
    JobStatus? status,
  }) {
    return CraftJob(
      id: id,
      title: title,
      organizationOrBuyer: organizationOrBuyer,
      location: location,
      requiredCraft: requiredCraft,
      stipendOrBudget: stipendOrBudget,
      duration: duration,
      description: description,
      status: status ?? this.status,
      applicantNames: applicantNames ?? this.applicantNames,
    );
  }
}
