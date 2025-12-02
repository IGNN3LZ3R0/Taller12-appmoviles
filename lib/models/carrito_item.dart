import 'producto.dart';

class CarritoItem {
  final Producto producto;
  int cantidad;
  final int stockDisponible;

  CarritoItem({
    required this.producto,
    required this.cantidad,
    this.stockDisponible = 10, // Stock mock por defecto
  });

  // Calcular el subtotal de este item
  double get subtotal => producto.precio * cantidad;

  // Verificar si se puede agregar más cantidad
  bool puedaAgregar(int cantidadAgregar) {
    return (cantidad + cantidadAgregar) <= stockDisponible;
  }

  // Crear copia con cantidad actualizada
  CarritoItem copyWith({int? cantidad}) {
    return CarritoItem(
      producto: producto,
      cantidad: cantidad ?? this.cantidad,
      stockDisponible: stockDisponible,
    );
  }
}