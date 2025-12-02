import 'dart:math';
import '../models/producto.dart';
import '../models/carrito_item.dart';

class CarritoService {
  // Singleton pattern
  static final CarritoService _instance = CarritoService._internal();
  factory CarritoService() => _instance;
  CarritoService._internal();

  // Almacenamiento en memoria del carrito
  final List<CarritoItem> _items = [];
  final Random _random = Random();

  // Probabilidad de error (20%)
  static const double _errorProbability = 0.2;

  // Mensajes de error posibles
  static const List<String> _erroresPosibles = [
    'Stock insuficiente',
    'Error de conexión',
    'Producto no disponible',
    'Sesión expirada',
  ];

  // Simular delay de red (1-2 segundos)
  Future<void> _simularDelay() async {
    await Future.delayed(
      Duration(milliseconds: 1000 + _random.nextInt(1000)),
    );
  }

  // Simular error aleatorio (20% de probabilidad)
  void _simularError() {
    if (_random.nextDouble() < _errorProbability) {
      final mensajeError = _erroresPosibles[_random.nextInt(_erroresPosibles.length)];
      throw Exception(mensajeError);
    }
  }

  // 1. AGREGAR PRODUCTO AL CARRITO
  Future<void> agregarProducto(Producto producto, int cantidad) async {
    await _simularDelay();
    _simularError();

    // Buscar si el producto ya existe en el carrito
    final index = _items.indexWhere((item) => item.producto.id == producto.id);

    if (index != -1) {
      // Producto ya existe - verificar stock
      final itemExistente = _items[index];
      if (!itemExistente.puedaAgregar(cantidad)) {
        throw Exception('Stock insuficiente. Solo quedan ${itemExistente.stockDisponible - itemExistente.cantidad} unidades disponibles');
      }
      // Incrementar cantidad
      _items[index] = itemExistente.copyWith(
        cantidad: itemExistente.cantidad + cantidad,
      );
    } else {
      // Producto nuevo - agregar al carrito
      if (cantidad > 10) {
        throw Exception('Stock insuficiente. Máximo 10 unidades por producto');
      }
      _items.add(CarritoItem(
        producto: producto,
        cantidad: cantidad,
      ));
    }
  }

  // 2. ELIMINAR PRODUCTO DEL CARRITO
  Future<void> eliminarProducto(String productoId) async {
    await _simularDelay();
    _simularError();

    _items.removeWhere((item) => item.producto.id == productoId);
  }

  // 3. ACTUALIZAR CANTIDAD DE UN PRODUCTO
  Future<void> actualizarCantidad(String productoId, int nuevaCantidad) async {
    await _simularDelay();
    _simularError();

    // Validar cantidad mínima
    if (nuevaCantidad < 1) {
      throw Exception('La cantidad debe ser al menos 1');
    }

    final index = _items.indexWhere((item) => item.producto.id == productoId);
    
    if (index == -1) {
      throw Exception('Producto no encontrado en el carrito');
    }

    final item = _items[index];

    // Validar stock disponible
    if (nuevaCantidad > item.stockDisponible) {
      throw Exception('Stock insuficiente. Máximo ${item.stockDisponible} unidades disponibles');
    }

    _items[index] = item.copyWith(cantidad: nuevaCantidad);
  }

  // 4. OBTENER ITEMS DEL CARRITO
  Future<List<CarritoItem>> obtenerItems() async {
    await _simularDelay();
    _simularError();

    // Retornar una copia de la lista
    return List.from(_items);
  }

  // 5. VACIAR CARRITO COMPLETO
  Future<void> vaciarCarrito() async {
    await _simularDelay();
    _simularError();

    _items.clear();
  }

  // 6. CALCULAR TOTALES
  Future<Map<String, double>> calcularTotales() async {
    await _simularDelay();
    _simularError();

    // Calcular subtotal
    double subtotal = 0;
    for (var item in _items) {
      subtotal += item.subtotal;
    }

    // Calcular descuento (10% si el total > $100)
    double descuento = 0;
    if (subtotal > 100) {
      descuento = subtotal * 0.10;
    }

    // Calcular subtotal con descuento
    double subtotalConDescuento = subtotal - descuento;

    // Calcular impuestos (12% sobre el subtotal con descuento)
    double impuestos = subtotalConDescuento * 0.12;

    // Calcular total final
    double total = subtotalConDescuento + impuestos;

    return {
      'subtotal': subtotal,
      'descuento': descuento,
      'impuestos': impuestos,
      'total': total,
    };
  }

  // Método para obtener la cantidad de items (sin simular delay)
  int get cantidadItems => _items.length;

  // Método para obtener cantidad total de productos
  int get cantidadTotalProductos {
    int total = 0;
    for (var item in _items) {
      total += item.cantidad;
    }
    return total;
  }
}