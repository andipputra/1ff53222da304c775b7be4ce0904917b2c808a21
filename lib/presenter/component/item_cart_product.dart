import 'package:kulina_1ff53222da304c775b7be4ce0904917b2c808a21/bloc/cart/cart_data_bloc/cart_data_bloc.dart';
import 'package:kulina_1ff53222da304c775b7be4ce0904917b2c808a21/bloc/cart/list_cart_bloc/list_cart_bloc.dart';
import 'package:kulina_1ff53222da304c775b7be4ce0904917b2c808a21/bloc/cart/remove_cart_bloc/remove_cart_bloc.dart';
import 'package:kulina_1ff53222da304c775b7be4ce0904917b2c808a21/bloc/cart/update_cart_bloc/update_cart_bloc.dart';
import 'package:kulina_1ff53222da304c775b7be4ce0904917b2c808a21/data/models/cart.dart';
import 'package:kulina_1ff53222da304c775b7be4ce0904917b2c808a21/data/models/product.dart';
import 'package:kulina_1ff53222da304c775b7be4ce0904917b2c808a21/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemCartProduct extends StatefulWidget {
  ItemCartProduct(this.cart, this.products);

  final Cart cart;
  final List<Product> products;

  @override
  _ItemCartProductState createState() => _ItemCartProductState();
}

class _ItemCartProductState extends State<ItemCartProduct> {
  late Product product;

  late UpdateCartBloc _updateCartBloc;
  late RemoveCartBloc _removeCartBloc;
  late ListCartBloc _listCartBloc;

  @override
  void initState() {
    _updateCartBloc = context.read<UpdateCartBloc>();
    _removeCartBloc = context.read<RemoveCartBloc>();
    _listCartBloc = context.read<ListCartBloc>();

    super.initState();

    product =
        widget.products.singleWhere((prod) => prod.id == widget.cart.productId);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UpdateCartBloc, UpdateCartState>(
            listener: (context, state) {
          if (state is UpdateCartSuccess) {
            _listCartBloc.add(GetListCart());
          }
        }),
        BlocListener<RemoveCartBloc, RemoveCartState>(
            listener: (context, state) {
          if (state is RemoveCartSuccess) {
            _listCartBloc.add(GetListCart());
          }
        })
      ],
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              flex: 7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                          child: Text(
                        product.name,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      )),
                      SizedBox(width: 8),
                      GestureDetector(
                        child: Icon(Icons.delete),
                        onTap: () {
                          _removeCartBloc.add(RemoveCart(widget.cart));
                        },
                      )
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    product.brandName,
                    style: Theme.of(context).textTheme.caption!.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rp. ${Global().numFormat(product.price * widget.cart.orderCount)}',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                        padding: EdgeInsets.all(2),
                        child: Row(
                          children: [
                            GestureDetector(
                              child: Icon(
                                Icons.remove,
                                size: 18,
                              ),
                              onTap: widget.cart.orderCount != 1
                                  ? () {
                                      _updateCartBloc
                                          .add(DecrementCart(widget.cart));
                                    }
                                  : null,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text(widget.cart.orderCount.toString()),
                            ),
                            GestureDetector(
                              child: Icon(
                                Icons.add,
                                size: 18,
                              ),
                              onTap: () {
                                _updateCartBloc.add(IncrementCart(widget.cart));
                              },
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
