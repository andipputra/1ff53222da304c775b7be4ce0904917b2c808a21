import 'package:a7c702b6ff83b7e07dfdd2f058f00da3d1f54092/bloc/cart/add_cart_bloc/add_cart_bloc.dart';
import 'package:a7c702b6ff83b7e07dfdd2f058f00da3d1f54092/bloc/cart/cart_data_bloc/cart_data_bloc.dart';
import 'package:a7c702b6ff83b7e07dfdd2f058f00da3d1f54092/bloc/cart/detail_cart_bloc/detail_cart_bloc.dart';
import 'package:a7c702b6ff83b7e07dfdd2f058f00da3d1f54092/bloc/cart/remove_cart_bloc/remove_cart_bloc.dart';
import 'package:a7c702b6ff83b7e07dfdd2f058f00da3d1f54092/bloc/cart/update_cart_bloc/update_cart_bloc.dart';
import 'package:a7c702b6ff83b7e07dfdd2f058f00da3d1f54092/data/models/cart.dart';
import 'package:a7c702b6ff83b7e07dfdd2f058f00da3d1f54092/data/models/product.dart';
import 'package:a7c702b6ff83b7e07dfdd2f058f00da3d1f54092/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemProduct extends StatefulWidget {
  const ItemProduct(
      {Key? key, required this.product, required this.dateSelected})
      : super(key: key);

  final Product product;

  final DateTime dateSelected;

  @override
  _ItemProductState createState() => _ItemProductState();
}

class _ItemProductState extends State<ItemProduct> {
  late AddCartBloc _addCartBloc;
  late UpdateCartBloc _updateCartBloc;
  late DetailCartBloc _detailCartBloc;
  late CartDataBloc _dataCartBloc;

  Cart? _cart;

  int selectedItem = 0;

  @override
  void initState() {
    _addCartBloc = context.read<AddCartBloc>();
    _detailCartBloc = context.read<DetailCartBloc>();
    _updateCartBloc = context.read<UpdateCartBloc>();
    _dataCartBloc = context.read<CartDataBloc>();

    super.initState();
  }

  createCart() {
    final cart = Cart(
        orderDate: widget.dateSelected,
        orderCount: 1,
        productId: widget.product.id);

    _addCartBloc.add(AddToCart(cart));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AddCartBloc, AddCartState>(listener: (context, state) {
          if (state is AddCartSuccess) {
            _detailCartBloc.add(GetAllCartDetail(widget.dateSelected));
          }
        }),
        BlocListener<UpdateCartBloc, UpdateCartState>(
            listener: (context, state) {
          if (state is UpdateCartSuccess) {
            _detailCartBloc.add(GetAllCartDetail(widget.dateSelected));
          }
        }),
        BlocListener<DetailCartBloc, DetailCartState>(
            listener: (context, state) {
          if (state is DetailAllCartSuccess) {
            _dataCartBloc.add(GetCartData());

            final cartList = state.carts;

            cartList.forEach((element) {
              if (element.productId == widget.product.id) {
                setState(() {
                  _cart = element;
                  selectedItem = _cart!.orderCount;
                });
              }
            });
          }
        }),
      ],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1.5,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(4),
                  ),
                  child: Image.network(
                    widget.product.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                height: 2,
              ),
              widget.product.rating < 1
                  ? Container(
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      padding: EdgeInsets.all(4),
                      child: Text(
                        'Baru',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .copyWith(color: Colors.white),
                      ),
                    )
                  : Row(
                      children: [
                        Text(widget.product.rating.toStringAsFixed(1),
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2!
                                .copyWith(fontWeight: FontWeight.bold)),
                        SizedBox(
                          width: 4,
                        ),
                        RatingBarIndicator(
                          rating: widget.product.rating,
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 16.0,
                          direction: Axis.horizontal,
                        ),
                      ],
                    ),
              SizedBox(
                height: 4,
              ),
              Text(
                '${widget.product.name}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(
                height: 4,
              ),
              Text('by ${widget.product.brandName}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.caption!.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.grey)),
              SizedBox(
                height: 4,
              ),
              Text('${widget.product.packageName}',
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(color: Colors.grey)),
            ],
          ),
          Column(
            children: [
              RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                      text: 'Rp. ${Global().numFormat(widget.product.price)} ',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: Colors.black, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                            text: 'termasuk ongkir',
                            style: Theme.of(context).textTheme.caption)
                      ])),
              SizedBox(
                height: 4,
              ),
              if (selectedItem == 0)
                GestureDetector(
                  onTap: createCart,
                  child: Container(
                    child: Text(
                      'Tambah ke Keranjang',
                      style: Theme.of(context).textTheme.caption!.copyWith(
                          color: Colors.red, fontWeight: FontWeight.w600),
                    ),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                      border: Border.all(
                        color: Colors.red,
                      ),
                    ),
                  ),
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _updateCartBloc.add(DecrementCart(_cart!));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                            border: Border.all(
                              color: Colors.grey,
                            ),
                          ),
                          child: Icon(
                            Icons.remove,
                            color: Colors.red,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                        child: Text(
                          '$selectedItem',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _updateCartBloc.add(IncrementCart(_cart!));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                            border: Border.all(
                              color: Colors.grey,
                            ),
                          ),
                          child: Icon(
                            Icons.add,
                            color: Colors.red,
                            size: 16,
                          ),
                        ),
                      ),
                    )
                  ],
                )
            ],
          )
        ],
      ),
    );
  }
}
