import 'package:kulina_1ff53222da304c775b7be4ce0904917b2c808a21/bloc/cart/cart_data_bloc/cart_data_bloc.dart';
import 'package:kulina_1ff53222da304c775b7be4ce0904917b2c808a21/bloc/cart/list_cart_bloc/list_cart_bloc.dart';
import 'package:kulina_1ff53222da304c775b7be4ce0904917b2c808a21/bloc/cart/remove_cart_bloc/remove_cart_bloc.dart';
import 'package:kulina_1ff53222da304c775b7be4ce0904917b2c808a21/data/models/cart_by_date.dart';
import 'package:kulina_1ff53222da304c775b7be4ce0904917b2c808a21/data/models/product.dart';
import 'package:kulina_1ff53222da304c775b7be4ce0904917b2c808a21/global.dart';
import 'package:kulina_1ff53222da304c775b7be4ce0904917b2c808a21/presenter/component/item_cart_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  Widget loadingView() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _listCartBloc = context.read<ListCartBloc>();
    final _dataCartBloc = context.read<CartDataBloc>();
    final _removeCartBloc = context.read<RemoveCartBloc>();

    _listCartBloc.add(GetListCart());

    return Scaffold(
      appBar: AppBar(
        // title: Text('Review Pesanan'),
        flexibleSpace: FlexibleSpaceBar(
          title: Text(
            'Review Pesanan',
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: Colors.black),
          ),
        ),
        leading: Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
      ),
      body: Stack(
        children: [
          BlocBuilder<ListCartBloc, ListCartState>(
            builder: (context, state) {
              var listCartByDate = <CartByDate>[];
              var listProduct = <Product>[];

              if (state is ListCartSuccess) {
                _dataCartBloc.add(GetCartData());

                listCartByDate = state.cartData.cartByDate;

                listProduct = state.cartData.products;
              }

              if (state is ListCartLoading) {
                return loadingView();
              }

              if (state is ListCartEmpty) {
                _dataCartBloc.add(GetCartData());
                return Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.warning,
                        color: Colors.amberAccent,
                        size: 64,
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Text(
                        'Keranjang kamu masih kosong nih',
                        style: Theme.of(context).textTheme.bodyText1,
                      )
                    ],
                  ),
                );
              }

              return Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Daftar Pesanan',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                          ),
                          GestureDetector(
                            onTap: () {
                              _removeCartBloc.add(RemoveAllCart());
                            },
                            child: Text(
                              'Hapus Pesanan',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        itemBuilder: (context, i) => ItemCartDateList(
                          cartByDate: listCartByDate[i],
                          listProduct: listProduct,
                        ),
                        separatorBuilder: (context, i) => Divider(
                          thickness: 2,
                        ),
                        itemCount: listCartByDate.length,
                      ),
                    )
                  ],
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: kBottomNavigationBarHeight,
                decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                margin: EdgeInsets.all(16),
                child: BlocBuilder<CartDataBloc, CartDataState>(
                  builder: (context, state) {
                    if (state is CartDataSuccess) {
                      if (state.cartSumamry.totalItem < 1) {
                        return Center(
                          child: Text(
                            'Pesan Sekarang',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${state.cartSumamry.totalItem} Item |  Rp ${Global().numFormat(state.cartSumamry.totalPrice)}',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                'Termasuk ongkos kirim',
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'CHECKOUT',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Icon(Icons.chevron_right_rounded,
                                  size: 18, color: Colors.white)
                            ],
                          )
                        ],
                      );
                    }
                    return loadingView();
                  },
                ),
              ),
            ),
          ),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: BlocBuilder<CartDataBloc, CartDataState>(
          //       builder: (context, state) {
          //     if (state is CartDataSuccess &&
          //         state.cartSumamry.totalItem != 0) {
          //       return GestureDetector(
          //         onTap: () {
          //           Navigator.pop(context);
          //         },
          //         child: Container(
          //           height: 72,
          //           decoration: BoxDecoration(
          //               color: Colors.redAccent,
          //               borderRadius: BorderRadius.all(Radius.circular(8))),
          //           padding: EdgeInsets.all(16),
          //           margin: EdgeInsets.all(16),
          //           child:
          //             ],
          //           ),
          //         ),
          //       );
          //     }
          //
          //     return Container();
          //   }),
          // )
        ],
      ),
    );
  }
}

class ItemCartDateList extends StatelessWidget {
  const ItemCartDateList(
      {Key? key, required this.cartByDate, required this.listProduct})
      : super(key: key);
  final CartByDate cartByDate;
  final List<Product> listProduct;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(cartByDate.date),
        SizedBox(
          height: 4,
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, i) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ItemCartProduct(cartByDate.carts[i], listProduct),
          ),
          itemCount: cartByDate.carts.length,
        )
      ],
    );
  }
}
