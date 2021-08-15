import 'package:a7c702b6ff83b7e07dfdd2f058f00da3d1f54092/bloc/cart/cart_data_bloc/cart_data_bloc.dart';
import 'package:a7c702b6ff83b7e07dfdd2f058f00da3d1f54092/bloc/cart/detail_cart_bloc/detail_cart_bloc.dart';
import 'package:a7c702b6ff83b7e07dfdd2f058f00da3d1f54092/data/models/cart.dart';
import 'package:a7c702b6ff83b7e07dfdd2f058f00da3d1f54092/data/models/product.dart';
import 'package:a7c702b6ff83b7e07dfdd2f058f00da3d1f54092/global.dart';
import 'package:a7c702b6ff83b7e07dfdd2f058f00da3d1f54092/presenter/cart_screen/cart_screen.dart';
import 'package:a7c702b6ff83b7e07dfdd2f058f00da3d1f54092/presenter/component/item_product.dart';
import 'package:a7c702b6ff83b7e07dfdd2f058f00da3d1f54092/bloc/product/product_bloc/product_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late ProductBloc _bloc;
  late ScrollController _scrollController;
  late DateTime _selectedDay;

  @override
  void initState() {
    _bloc = context.read<ProductBloc>();
    _scrollController = ScrollController();

    _selectedDay = DateTime.now();

    super.initState();

    getFirstProductData();
    setupScrollController(context);
  }

  void setupScrollController(context) {
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels != 0) {
          getNextData();
        }
      }
    });
  }

  getFirstProductData() {
    _bloc.add(GetFirstProduct());
  }

  getNextData() {
    if (!_bloc.isLastPage) {
      _bloc.add(GetNextProduct());
    } else {
      print('is last page');
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay) &&
        selectedDay.weekday != DateTime.sunday &&
        selectedDay.weekday != DateTime.saturday) {
      setState(() {
        _selectedDay = selectedDay;
      });
      getFirstProductData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  Text(
                    'Alamat Pengiriman',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Icon(Icons.expand_more_rounded)
                ],
              ),
              Text(
                'Kulina',
                style: Theme.of(context).textTheme.headline6,
              )
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          BlocBuilder<ProductBloc, ProductState>(builder: (context, state) {
            if (state is ProductGetted) {
              context
                  .read<DetailCartBloc>()
                  .add(GetAllCartDetail(_selectedDay));
            }

            return PagedGridView(
              padding:
                  EdgeInsets.only(top: 96, left: 24, right: 24, bottom: 64),
              pagingController: _bloc.listController,
              scrollController: _scrollController,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1 / 2,
              ),
              builderDelegate: PagedChildBuilderDelegate<Product>(
                itemBuilder: (context, item, position) {
                  return ItemProduct(
                    product: item,
                    dateSelected: _selectedDay,
                  );
                },
                firstPageProgressIndicatorBuilder: (context) {
                  return firstProgressView();
                },
                firstPageErrorIndicatorBuilder: (context) {
                  return firstProgressView();
                },
                newPageProgressIndicatorBuilder: (context) {
                  return firstProgressView();
                },
              ),
            );
          }),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              color: Colors.white,
              height: 92,
              padding: EdgeInsets.symmetric(vertical: 8),
              child: TableCalendar(
                locale: 'id_ID',
                focusedDay: _selectedDay,
                headerVisible: false,
                firstDay: DateTime(2010),
                rowHeight: kToolbarHeight,
                lastDay: DateTime(2030),
                calendarFormat: CalendarFormat.week,
                daysOfWeekVisible: true,
                startingDayOfWeek: StartingDayOfWeek.monday,
                onDaySelected: _onDaySelected,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                calendarBuilders: CalendarBuilders(
                  dowBuilder: (context, day) {
                    if (day.weekday == DateTime.sunday) {
                      final text = DateFormat.E('id_ID').format(day);

                      return Center(
                        child: Text(
                          text,
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    }

                    if (day.weekday == DateTime.saturday) {
                      final text = DateFormat.E('id_ID').format(day);

                      return Center(
                        child: Text(
                          text,
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    }
                  },
                ),
                calendarStyle: CalendarStyle(isTodayHighlighted: false),
                headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    leftChevronVisible: false,
                    rightChevronVisible: false,
                    titleCentered: true),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BlocBuilder<CartDataBloc, CartDataState>(
                builder: (context, state) {
              if (state is CartDataSuccess &&
                  state.cartSumamry.totalItem != 0) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CartScreen()));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    height: 72,
                    margin: EdgeInsets.all(24),
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                '${state.cartSumamry.totalItem} Item | Rp ${Global().numFormat(state.cartSumamry.totalPrice)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                            Text('Termasuk ongkos kirim',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Container();
            }),
          )
        ],
      ),
    );
  }

  Widget firstProgressView() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
