class ProposalResponse {
  final String status;
  final String message;
  final List<ProposalData> data;

  ProposalResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ProposalResponse.fromJson(Map<String, dynamic> json) {
    return ProposalResponse(
      status: json['status'],
      message: json['message'],
      data: List<ProposalData>.from(
        json['data'].map((x) => ProposalData.fromJson(x)),
      ),
    );
  }
}

class ProposalData {
  final int id;
  final int clientId;
  final String fname;
  final String lname;
  final String age;
  final String nickname;
  final int isVerified;
  final String message;
  final int proposalStatus;
  final String? cancelReason;
  final String image;

  ProposalData({
    required this.id,
    required this.clientId,
    required this.fname,
    required this.lname,
    required this.age,
    required this.nickname,
    required this.isVerified,
    required this.message,
    required this.proposalStatus,
    this.cancelReason,
    required this.image,
  });

  factory ProposalData.fromJson(Map<String, dynamic> json) {
    return ProposalData(
      id: json['id'],
      clientId: json['client_id'],
      fname: json['fname'],
      lname: json['lname'],
      age: json['age'].toString(),
      nickname: json['nickname'],
      isVerified: json['is_verified'],
      message: json['message']??"",
      proposalStatus: json['proposal_status'],
      cancelReason: json['cancel_reason'],
      image: json['image'],
    );
  }
}
