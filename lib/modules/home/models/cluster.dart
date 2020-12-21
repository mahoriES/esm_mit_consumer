import 'package:eSamudaay/modules/register/model/register_request_model.dart';

class Cluster {
  String clusterId;
  String clusterName;
  String description;
  String clusterCode;
  Photo thumbnail;
  Photo introPhoto;

  Cluster(
      {this.clusterId,
      this.clusterName,
      this.description,
      this.clusterCode,
      this.introPhoto,
      this.thumbnail});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Cluster &&
          runtimeType == other.runtimeType &&
          clusterId == other.clusterId &&
          clusterName == other.clusterName &&
          description == other.description &&
          clusterCode == other.clusterCode &&
          thumbnail == other.thumbnail &&
          introPhoto == other.introPhoto;

  @override
  int get hashCode =>
      clusterId.hashCode ^
      clusterName.hashCode ^
      description.hashCode ^
      clusterCode.hashCode ^
      thumbnail.hashCode ^
      introPhoto.hashCode;

  Cluster.fromJson(Map<String, dynamic> json) {
    clusterId = json['cluster_id'];
    clusterName = json['cluster_name'];
    description = json['description'];
    clusterCode = json['cluster_code'];
    if (json['thumb'] != null && json['thumb'] is Map)
      thumbnail = Photo.fromJson(json['thumb']);
    if (json['intro'] != null && json['intro'] is Map )
      introPhoto = Photo.fromJson(json['intro']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cluster_id'] = this.clusterId;
    data['cluster_name'] = this.clusterName;
    data['description'] = this.description;
    data['cluster_code'] = this.clusterCode;
    if (data['intro'] != null)
      data['intro'] = this.introPhoto.toJson();
    if (data['thumb'] != null)
      data['thumb'] = this.thumbnail.toJson();
    return data;
  }
}
