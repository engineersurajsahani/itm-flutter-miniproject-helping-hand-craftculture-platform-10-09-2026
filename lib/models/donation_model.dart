/// ============================================================================
/// VIVA EXPLANATION HEADER
/// CONCEPT: Practical 15 & 16 - Data Serialization & Donation Tracking
/// LOGIC  : Tracks money contributions & physical material donations
///          (e.g., Clay, Yarn, Wood) with target vs current progress amounts.
/// VIVA TIP: How does progress ratio computation work?
///          - Progress is computed dynamically as (raised / target).clamp(0.0, 1.0).
/// ============================================================================

enum DonationType { money, rawMaterial }

class DonationItem {
  final String id;
  final String title;
  final String targetArtisanOrCluster;
  final DonationType type;
  final String unit; // 'USD' / '₹' or 'kg' / 'spools' / 'blocks'
  final double targetAmount;
  final double raisedAmount;
  final String description;
  final String imageUrl;

  DonationItem({
    required this.id,
    required this.title,
    required this.targetArtisanOrCluster,
    required this.type,
    required this.unit,
    required this.targetAmount,
    required this.raisedAmount,
    required this.description,
    required this.imageUrl,
  });

  double get progressPercentage {
    if (targetAmount == 0) return 0.0;
    return (raisedAmount / targetAmount).clamp(0.0, 1.0);
  }

  DonationItem copyWith({double? additionalRaised}) {
    return DonationItem(
      id: id,
      title: title,
      targetArtisanOrCluster: targetArtisanOrCluster,
      type: type,
      unit: unit,
      targetAmount: targetAmount,
      raisedAmount: raisedAmount + (additionalRaised ?? 0),
      description: description,
      imageUrl: imageUrl,
    );
  }
}
