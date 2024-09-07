import '../../../../app/constants.dart';
import '../../../../app/extensions.dart';
import '../../domain/model/base_response_entity.dart';
import '../responses/base_response.dart';

extension BaseMapper on BaseResponse? {
  BaseResponseEntity toDomain() {
    return BaseResponseEntity(
      status: this?.status.orBool() ?? false,
      id: this?.id.orZero() ?? Constants.zero,
      message: this?.message.orEmpty() ?? Constants.empty,
      code: this?.code.orZero() ?? Constants.zero,
    );
  }
}
