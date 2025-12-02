import 'package:flutter/material.dart';
import '../services/carrito_service.dart';

class BarraNavegacion extends StatefulWidget {
  final int indiceActual;
  final Function(int) onTap;

  const BarraNavegacion({
    super.key,
    required this.indiceActual,
    required this.onTap,
  });

  @override
  State<BarraNavegacion> createState() => _BarraNavegacionState();
}

class _BarraNavegacionState extends State<BarraNavegacion> {
  final CarritoService _carritoService = CarritoService();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildBotonNav(0, Icons.home, 'Inicio'),
          _buildBotonNav(1, Icons.search, 'Buscar'),
          _buildBotonNav(2, Icons.favorite, 'Favoritos'),
          _buildBotonNavConBadge(3, Icons.shopping_cart, 'Carrito'),
          _buildBotonNav(4, Icons.person, 'Perfil'),
        ],
      ),
    );
  }

  Widget _buildBotonNav(int indice, IconData icono, String label) {
    final bool estaActivo = indice == widget.indiceActual;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => widget.onTap(indice),
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icono,
                color: estaActivo ? Colors.blue : Colors.grey,
                size: 26,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: estaActivo ? Colors.blue : Colors.grey,
                  fontSize: 11,
                  fontWeight: estaActivo ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBotonNavConBadge(int indice, IconData icono, String label) {
    final bool estaActivo = indice == widget.indiceActual;
    final int cantidadItems = _carritoService.cantidadTotalProductos;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => widget.onTap(indice),
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    icono,
                    color: estaActivo ? Colors.blue : Colors.grey,
                    size: 26,
                  ),
                  if (cantidadItems > 0)
                    Positioned(
                      right: -8,
                      top: -8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          cantidadItems > 99 ? '99+' : '$cantidadItems',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: estaActivo ? Colors.blue : Colors.grey,
                  fontSize: 11,
                  fontWeight: estaActivo ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}