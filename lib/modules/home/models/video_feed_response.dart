class VideoFeedResponse {
  int count;
  Null next;
  Null previous;
  List<Results> results;

  VideoFeedResponse({this.count, this.next, this.previous, this.results});

  VideoFeedResponse.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = new List<Results>();
      json['results'].forEach((v) {
        results.add(new Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['next'] = this.next;
    data['previous'] = this.previous;
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  String postId;
  String title;
  User user;
  _Business business;
  String circleId;
  String businessId;
  String status;
  String postType;
  Content content;
  String created;

  Results(
      {this.postId,
      this.title,
      this.user,
      this.business,
      this.circleId,
      this.businessId,
      this.status,
      this.postType,
      this.content,
      this.created});

  Results.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'];
    title = json['title'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    business = json['business'] != null
        ? new _Business.fromJson(json['business'])
        : null;
    circleId = json['circle_id'];
    businessId = json['business_id'];
    status = json['status'];
    postType = json['post_type'];
    content =
        json['content'] != null ? new Content.fromJson(json['content']) : null;
    created = json['created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['post_id'] = this.postId;
    data['title'] = this.title;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.business != null) {
      data['business'] = this.business.toJson();
    }
    data['circle_id'] = this.circleId;
    data['business_id'] = this.businessId;
    data['status'] = this.status;
    data['post_type'] = this.postType;
    if (this.content != null) {
      data['content'] = this.content.toJson();
    }
    data['created'] = this.created;
    return data;
  }
}

class User {
  String name;
  _Photo photo;

  User({this.name, this.photo});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    photo = json['photo'] != null ? new _Photo.fromJson(json['photo']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.photo != null) {
      data['photo'] = this.photo.toJson();
    }
    return data;
  }
}

class _Photo {
  _Photo.fromJson(Map<String, dynamic> json) {}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}

class _Business {
  String name;
  _Photo photo;

  _Business({this.name, this.photo});

  _Business.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['photo'] = this.photo;
    return data;
  }
}

class Content {
  Video video;

  Content({this.video});

  Content.fromJson(Map<String, dynamic> json) {
    video = json['video'] != null ? new Video.fromJson(json['video']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.video != null) {
      data['video'] = this.video.toJson();
    }
    return data;
  }
}

class Video {
  int width;
  int height;
  int duration;
  Original original;
  String playUrl;
  String thumbnail;
  String aspectRatio;
  String maxResolution;

  Video(
      {this.width,
      this.height,
      this.duration,
      this.original,
      this.playUrl,
      this.thumbnail,
      this.aspectRatio,
      this.maxResolution});

  Video.fromJson(Map<String, dynamic> json) {
    width = json['width'];
    height = json['height'];
    duration = json['duration'];
    original = json['original'] != null
        ? new Original.fromJson(json['original'])
        : null;
    playUrl = json['play_url'];
    thumbnail = json['thumbnail'];
    aspectRatio = json['aspect_ratio'];
    maxResolution = json['max_resolution'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['width'] = this.width;
    data['height'] = this.height;
    data['duration'] = this.duration;
    if (this.original != null) {
      data['original'] = this.original.toJson();
    }
    data['play_url'] = this.playUrl;
    data['thumbnail'] = this.thumbnail;
    data['aspect_ratio'] = this.aspectRatio;
    data['max_resolution'] = this.maxResolution;
    return data;
  }
}

class Original {
  String videoId;
  String videoUrl;

  Original({this.videoId, this.videoUrl});

  Original.fromJson(Map<String, dynamic> json) {
    videoId = json['video_id'];
    videoUrl = json['video_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['video_id'] = this.videoId;
    data['video_url'] = this.videoUrl;
    return data;
  }
}
