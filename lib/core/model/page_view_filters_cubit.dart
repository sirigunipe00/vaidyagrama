

import 'package:app/core/cubit/base/base_cubit.dart';
import 'package:app/core/model/page_view_filters.dart';


abstract class PageViewFiltersCubit extends AppBaseCubit<PageViewFilters> {
  PageViewFiltersCubit(super.state);

  void onChangeStatus(String status);

  void onSearch([String? query]);
}
