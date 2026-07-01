import 'package:flutter/material.dart';
import '../models/calculator_tool.dart';

class CalculatorsData {
  static final List<CalculatorTool> tools = [

    // ── PINTURA / PAINTING ──────────────────────────────────────────────────
    CalculatorTool(
      id: 'calc_paint',
      titleEs: 'Cuánta pintura necesito',
      titleEn: 'How much paint do I need',
      tradeId: 'drywall_painting',
      categoryEs: 'Pintura',
      categoryEn: 'Painting',
      descriptionEs: 'Calcula los galones necesarios para pintar una habitación.',
      descriptionEn: 'Calculate gallons needed to paint a room.',
      icon: Icons.format_paint,
      fields: [
        const CalculatorField(key: 'length', labelEs: 'Largo', labelEn: 'Length', unitEs: 'ft', unitEn: 'ft'),
        const CalculatorField(key: 'width', labelEs: 'Ancho', labelEn: 'Width', unitEs: 'ft', unitEn: 'ft'),
        const CalculatorField(key: 'height', labelEs: 'Altura', labelEn: 'Height', unitEs: 'ft', unitEn: 'ft'),
        const CalculatorField(key: 'coats', labelEs: 'Capas', labelEn: 'Coats', defaultValue: 2),
      ],
      calculate: (inputs) {
        double area = 2 * (inputs['length']! + inputs['width']!) * inputs['height']!;
        double gallons = (area / 350) * (inputs['coats'] ?? 2);
        return {'area': area, 'gallons': gallons};
      },
      resultTemplateEs: 'Área de paredes: {area} sq ft\nGalones necesarios: {gallons} gal',
      resultTemplateEn: 'Wall area: {area} sq ft\nGallons needed: {gallons} gal',
      resultExplanationEs: 'Solo paredes (sin techo). Descuenta puertas y ventanas manualmente si es necesario.',
      resultExplanationEn: 'Walls only (no ceiling). Manually deduct doors and windows if needed.',
      shoppingItemsEs: ['Pintura (galones calculados)', 'Rodillo 9" + extensión', 'Bandeja para pintura', 'Brocha de corte 2"', 'Cinta de enmascarar azul', 'Lona protectora', 'Lija 220'],
      shoppingItemsEn: ['Paint (calculated gallons)', '9" roller + extension pole', 'Paint tray', '2" cutting brush', "Blue painter's tape", 'Drop cloth', '220-grit sandpaper'],
      disclaimerEs: 'Rendimiento estimado en 350 sq ft/galón sobre superficie lisa. Superficies porosas o texturizadas requieren más.',
      disclaimerEn: 'Estimated at 350 sq ft/gallon on smooth surfaces. Porous or textured surfaces require more.',
    ),

    CalculatorTool(
      id: 'calc_wallpaper',
      titleEs: 'Rollos de tapiz',
      titleEn: 'Wallpaper rolls',
      tradeId: 'drywall_painting',
      categoryEs: 'Pintura',
      categoryEn: 'Painting',
      descriptionEs: 'Calcula los rollos de tapiz necesarios para una habitación.',
      descriptionEn: 'Calculate wallpaper rolls needed for a room.',
      icon: Icons.texture,
      fields: [
        const CalculatorField(key: 'room_length', labelEs: 'Largo del cuarto', labelEn: 'Room length', unitEs: 'ft', unitEn: 'ft'),
        const CalculatorField(key: 'room_width', labelEs: 'Ancho del cuarto', labelEn: 'Room width', unitEs: 'ft', unitEn: 'ft'),
        const CalculatorField(key: 'height', labelEs: 'Altura de pared', labelEn: 'Wall height', unitEs: 'ft', unitEn: 'ft', defaultValue: 8),
        const CalculatorField(key: 'doors', labelEs: 'Número de puertas', labelEn: 'Number of doors', defaultValue: 2),
        const CalculatorField(key: 'windows', labelEs: 'Número de ventanas', labelEn: 'Number of windows', defaultValue: 2),
      ],
      calculate: (inputs) {
        final perimeter = 2 * (inputs['room_length']! + inputs['room_width']!);
        final wallArea = perimeter * inputs['height']!;
        final deductions = (inputs['doors']! * 21) + (inputs['windows']! * 15);
        final netArea = (wallArea - deductions).clamp(0.0, double.infinity);
        final rolls = (netArea / 56 * 1.10).ceil().toDouble();
        return {'wall_area': wallArea, 'net_area': netArea, 'rolls': rolls};
      },
      resultTemplateEs: 'Área bruta: {wall_area} sq ft\nÁrea neta: {net_area} sq ft\nRollos (+10%): {rolls}',
      resultTemplateEn: 'Gross area: {wall_area} sq ft\nNet area: {net_area} sq ft\nRolls (+10%): {rolls}',
      resultExplanationEs: 'Basado en rollos dobles de 56 sq ft (estándar EE.UU.). Verifica la cobertura en la etiqueta del producto.',
      resultExplanationEn: 'Based on 56 sq ft double rolls (US standard). Check coverage on product label.',
      shoppingItemsEs: ['Tapiz / wallpaper (rollos)', 'Pegamento para tapiz', 'Espátula / smoother', 'Cúter / exacto', 'Nivel de burbuja', 'Mesa de empapelar'],
      shoppingItemsEn: ['Wallpaper (rolls)', 'Wallpaper paste/adhesive', 'Smoothing squeegee', 'Utility knife', 'Bubble level', 'Wallpapering table'],
      disclaimerEs: 'Para tapices con patrón (pattern repeat), añade 15-25% adicional para cuadrar el diseño.',
      disclaimerEn: 'For patterned wallpaper, add 15-25% more to match the pattern repeat.',
    ),

    // ── PISOS / FLOORING ────────────────────────────────────────────────────
    CalculatorTool(
      id: 'calc_flooring',
      titleEs: 'Cuánto flooring comprar',
      titleEn: 'How much flooring to buy',
      tradeId: 'flooring',
      categoryEs: 'Pisos',
      categoryEn: 'Flooring',
      descriptionEs: 'Pies cuadrados de material con desperdicio incluido.',
      descriptionEn: 'Square feet of material with waste included.',
      icon: Icons.grid_view,
      fields: [
        const CalculatorField(key: 'length', labelEs: 'Largo', labelEn: 'Length', unitEs: 'ft', unitEn: 'ft'),
        const CalculatorField(key: 'width', labelEs: 'Ancho', labelEn: 'Width', unitEs: 'ft', unitEn: 'ft'),
      ],
      calculate: (inputs) {
        double area = inputs['length']! * inputs['width']!;
        double total = area * 1.10;
        return {'area': area, 'total': total};
      },
      resultTemplateEs: 'Área: {area} sq ft\nTotal (+10%): {total} sq ft',
      resultTemplateEn: 'Area: {area} sq ft\nTotal (+10%): {total} sq ft',
      resultExplanationEs: 'Para instalación diagonal o espiga (herringbone), usa +15% de desperdicio.',
      resultExplanationEn: 'For diagonal or herringbone installation, use +15% waste instead.',
      shoppingItemsEs: ['Material de piso (sq ft calculados)', 'Adhesivo o clips de instalación', 'Underlayment / relleno', 'Transiciones / moldes', 'Rodapié / baseboard'],
      shoppingItemsEn: ['Flooring (calculated sq ft)', 'Adhesive or installation clips', 'Underlayment / padding', 'Transition strips', 'Baseboard / shoe molding'],
    ),

    CalculatorTool(
      id: 'calc_tile',
      titleEs: 'Cuántas losas necesito',
      titleEn: 'How many tiles I need',
      tradeId: 'flooring',
      categoryEs: 'Pisos',
      categoryEn: 'Flooring',
      descriptionEs: 'Cantidad de tiles según área y tamaño con desperdicio.',
      descriptionEn: 'Tile count based on area and size with waste.',
      icon: Icons.border_inner,
      fields: [
        const CalculatorField(key: 'length', labelEs: 'Largo área', labelEn: 'Area length', unitEs: 'ft', unitEn: 'ft'),
        const CalculatorField(key: 'width', labelEs: 'Ancho área', labelEn: 'Area width', unitEs: 'ft', unitEn: 'ft'),
        const CalculatorField(key: 'size', labelEs: 'Tamaño losa', labelEn: 'Tile size', unitEs: 'in', unitEn: 'in', defaultValue: 12),
      ],
      calculate: (inputs) {
        double areaSqFt = inputs['length']! * inputs['width']!;
        double tileSizeSqFt = (inputs['size']! * inputs['size']!) / 144;
        double count = (areaSqFt / tileSizeSqFt) * 1.10;
        return {'area': areaSqFt, 'count': count.ceilToDouble()};
      },
      resultTemplateEs: 'Área: {area} sq ft\nCantidad (+10%): {count} tiles',
      resultTemplateEn: 'Area: {area} sq ft\nCount (+10%): {count} tiles',
      shoppingItemsEs: ['Tiles / losas (cantidad calculada)', 'Thin-set / mortero', 'Lechada / grout', 'Espaciadores de tile', 'Cortadora de tile', 'Llana dentada 1/4"'],
      shoppingItemsEn: ['Tiles (calculated count)', 'Thin-set / mortar', 'Grout', 'Tile spacers', 'Tile cutter / wet saw', '1/4" notched trowel'],
      disclaimerEs: '+10% ya incluido. Para patrones diagonales o complejos, añade 15% manualmente.',
      disclaimerEn: '+10% already included. For diagonal or complex patterns, add 15% manually.',
    ),

    // ── CONSTRUCCIÓN / CONSTRUCTION ─────────────────────────────────────────
    CalculatorTool(
      id: 'calc_drywall',
      titleEs: 'Planchas de drywall',
      titleEn: 'Drywall sheets',
      tradeId: 'drywall_painting',
      categoryEs: 'Construcción',
      categoryEn: 'Construction',
      descriptionEs: 'Cantidad de sheets de drywall necesarias con desperdicio.',
      descriptionEn: 'Number of drywall sheets needed with waste.',
      icon: Icons.layers,
      fields: [
        const CalculatorField(key: 'length', labelEs: 'Largo pared', labelEn: 'Wall length', unitEs: 'ft', unitEn: 'ft'),
        const CalculatorField(key: 'height', labelEs: 'Altura pared', labelEn: 'Wall height', unitEs: 'ft', unitEn: 'ft'),
      ],
      calculate: (inputs) {
        double area = inputs['length']! * inputs['height']!;
        double sheets = (area / 32) * 1.10;
        return {'area': area, 'sheets': sheets.ceilToDouble()};
      },
      resultTemplateEs: 'Área: {area} sq ft\nSheets 4×8 (+10%): {sheets}',
      resultTemplateEn: 'Area: {area} sq ft\nSheets 4×8 (+10%): {sheets}',
      resultExplanationEs: 'Basado en planchas estándar 4×8 ft (32 sq ft). Para múltiples paredes, suma por separado.',
      resultExplanationEn: 'Based on standard 4×8 ft sheets (32 sq ft). For multiple walls, sum separately.',
      shoppingItemsEs: ['Planchas drywall 4×8', 'Tornillos para drywall 1-5/8"', 'Joint compound / mud', 'Malla para juntas', 'Lija 120 y 220', 'Esquineros metálicos'],
      shoppingItemsEn: ['4×8 drywall sheets', '1-5/8" drywall screws', 'Joint compound / mud', 'Mesh joint tape', '120 and 220 sandpaper', 'Metal corner bead'],
    ),

    CalculatorTool(
      id: 'calc_concrete',
      titleEs: 'Bolsas de concreto',
      titleEn: 'Bags of concrete',
      tradeId: 'concrete_masonry',
      categoryEs: 'Construcción',
      categoryEn: 'Construction',
      descriptionEs: 'Calcula las bolsas de cemento para una losa o base.',
      descriptionEn: 'Calculate concrete bags needed for a slab or footing.',
      icon: Icons.foundation,
      fields: [
        const CalculatorField(key: 'length', labelEs: 'Largo', labelEn: 'Length', unitEs: 'ft', unitEn: 'ft'),
        const CalculatorField(key: 'width', labelEs: 'Ancho', labelEn: 'Width', unitEs: 'ft', unitEn: 'ft'),
        const CalculatorField(key: 'depth', labelEs: 'Profundidad / grosor', labelEn: 'Depth / thickness', unitEs: 'in', unitEn: 'in', defaultValue: 4),
        const CalculatorField(
          key: 'bag_size',
          labelEs: 'Tamaño de bolsa',
          labelEn: 'Bag size',
          type: CalculatorFieldType.dropdown,
          optionsEs: ['60 lb (0.45 cu ft)', '80 lb (0.60 cu ft)'],
          optionsEn: ['60 lb (0.45 cu ft)', '80 lb (0.60 cu ft)'],
        ),
      ],
      calculate: (inputs) {
        final cuFt = inputs['length']! * inputs['width']! * (inputs['depth']! / 12);
        final cuFtPerBag = inputs['bag_size']!.toInt() == 0 ? 0.45 : 0.60;
        final bags = (cuFt / cuFtPerBag * 1.10).ceil().toDouble();
        return {'cu_ft': cuFt, 'bags': bags};
      },
      resultTemplateEs: 'Volumen: {cu_ft} cu ft\nBolsas (+10%): {bags}',
      resultTemplateEn: 'Volume: {cu_ft} cu ft\nBags (+10%): {bags}',
      shoppingItemsEs: ['Bolsas de concreto', 'Tabla de encofrado (form board)', 'Mezcladora o balde grande', 'Varilla de refuerzo (rebar)', 'Nivel', 'Llana para alisar'],
      shoppingItemsEn: ['Concrete bags', 'Form board (lumber)', 'Mixer or large bucket', 'Rebar', 'Level', 'Concrete float/trowel'],
      disclaimerEs: 'Para losas mayores de 50 cu ft, considera ordenar concreto premezclado en camión. No mezcles en clima por debajo de 40°F.',
      disclaimerEn: 'For slabs over 50 cu ft, consider ordering ready-mix concrete. Do not mix in temps below 40°F.',
    ),

    CalculatorTool(
      id: 'calc_lumber',
      titleEs: 'Board feet de madera',
      titleEn: 'Board feet of lumber',
      tradeId: 'carpentry',
      categoryEs: 'Construcción',
      categoryEn: 'Construction',
      descriptionEs: 'Calcula los board feet totales para un proyecto de madera.',
      descriptionEn: 'Calculate total board feet for a lumber project.',
      icon: Icons.carpenter,
      fields: [
        const CalculatorField(key: 'quantity', labelEs: 'Cantidad de piezas', labelEn: 'Number of pieces', defaultValue: 1),
        const CalculatorField(key: 'length', labelEs: 'Largo de cada pieza', labelEn: 'Length of each piece', unitEs: 'ft', unitEn: 'ft'),
        const CalculatorField(key: 'width', labelEs: 'Ancho de cada pieza', labelEn: 'Width of each piece', unitEs: 'in', unitEn: 'in'),
        const CalculatorField(key: 'thickness', labelEs: 'Grosor de cada pieza', labelEn: 'Thickness of each piece', unitEs: 'in', unitEn: 'in', defaultValue: 1),
      ],
      calculate: (inputs) {
        final boardFeet = inputs['quantity']! * inputs['length']! * inputs['width']! * inputs['thickness']! / 12;
        final withWaste = boardFeet * 1.15;
        return {'board_feet': boardFeet, 'with_waste': withWaste};
      },
      resultTemplateEs: 'Board feet netos: {board_feet} BF\nCon desperdicio (+15%): {with_waste} BF',
      resultTemplateEn: 'Net board feet: {board_feet} BF\nWith waste (+15%): {with_waste} BF',
      resultExplanationEs: '1 BF = 1 ft × 1 ft × 1 in. Fórmula: cantidad × largo(ft) × ancho(in) × grosor(in) ÷ 12.',
      resultExplanationEn: '1 BF = 1 ft × 1 ft × 1 in. Formula: qty × length(ft) × width(in) × thickness(in) ÷ 12.',
      shoppingItemsEs: ['Madera (board feet calculados)', 'Lija 80 y 120', 'Cola de madera', 'Tornillos para madera', 'Sellador o barniz'],
      shoppingItemsEn: ['Lumber (calculated board feet)', '80 and 120 grit sandpaper', 'Wood glue', 'Wood screws', 'Sealant or varnish'],
    ),

    CalculatorTool(
      id: 'calc_stair',
      titleEs: 'Calculadora de escaleras',
      titleEn: 'Stair calculator',
      tradeId: 'carpentry',
      categoryEs: 'Construcción',
      categoryEn: 'Construction',
      descriptionEs: 'Calcula risers, tread y recorrido total de un tramo de escaleras.',
      descriptionEn: 'Calculate risers, tread depth, and total run of a staircase.',
      icon: Icons.stairs,
      fields: [
        const CalculatorField(key: 'total_rise', labelEs: 'Altura total (piso a piso)', labelEn: 'Total rise (floor to floor)', unitEs: 'in', unitEn: 'in'),
        const CalculatorField(key: 'stair_width', labelEs: 'Ancho de la escalera', labelEn: 'Stair width', unitEs: 'in', unitEn: 'in', defaultValue: 36),
      ],
      calculate: (inputs) {
        final totalRise = inputs['total_rise']!;
        final numRisers = (totalRise / 7.5).round().toDouble();
        final riserHeight = totalRise / numRisers;
        final treadDepth = (25 - (2 * riserHeight)).clamp(10.0, 16.0);
        final totalRun = (numRisers - 1) * treadDepth;
        return {'risers': numRisers, 'riser_height': riserHeight, 'tread_depth': treadDepth, 'total_run': totalRun};
      },
      resultTemplateEs: 'Número de risers: {risers}\nAltura de riser: {riser_height} in\nProfundidad de tread: {tread_depth} in\nRecorrido total: {total_run} in',
      resultTemplateEn: 'Number of risers: {risers}\nRiser height: {riser_height} in\nTread depth: {tread_depth} in\nTotal run: {total_run} in',
      resultExplanationEs: 'Fórmula de Blondel: 2×riser + tread = 25". Código IBC: riser máx 7.75", tread mín 10".',
      resultExplanationEn: "Blondel's formula: 2×riser + tread = 25\". IBC code: max riser 7.75\", min tread 10\".",
      shoppingItemsEs: ['Zancas (stringers) de madera', 'Tablones para tread (pisadera)', 'Tablillas para risers', 'Tornillos 3"', 'Pasamanos / handrail', 'Nivel'],
      shoppingItemsEn: ['Stair stringers (lumber)', 'Tread boards', 'Riser boards', '3" screws', 'Handrail', 'Level'],
      disclaimerEs: 'Verifica el código de construcción local. Todos los risers deben ser uniformes (variación máx ±3/8").',
      disclaimerEn: 'Check local building code. All risers must be uniform (max ±3/8" variation).',
    ),

    // ── ELECTRICIDAD / ELECTRICAL ───────────────────────────────────────────
    CalculatorTool(
      id: 'calc_watts_amps',
      titleEs: 'Watts a Amperios',
      titleEn: 'Watts to Amps',
      tradeId: 'electrical',
      categoryEs: 'Electricidad',
      categoryEn: 'Electrical',
      descriptionEs: 'Convierte potencia eléctrica en corriente.',
      descriptionEn: 'Convert electrical power to current.',
      icon: Icons.bolt,
      fields: [
        const CalculatorField(key: 'watts', labelEs: 'Watts', labelEn: 'Watts'),
        const CalculatorField(key: 'volts', labelEs: 'Voltaje', labelEn: 'Voltage', defaultValue: 120),
      ],
      calculate: (inputs) {
        double amps = inputs['watts']! / inputs['volts']!;
        return {'amps': amps};
      },
      resultTemplateEs: 'Corriente: {amps} Amps',
      resultTemplateEn: 'Current: {amps} Amps',
      resultExplanationEs: 'Fórmula: Amperios = Watts ÷ Voltaje. Para sistemas trifásicos: A = W ÷ (V × 1.732).',
      resultExplanationEn: 'Formula: Amps = Watts ÷ Voltage. For 3-phase systems: A = W ÷ (V × 1.732).',
      disclaimerEs: 'Para corriente alterna (CA) residencial. No aplica a circuitos de corriente directa (CD).',
      disclaimerEn: 'For residential alternating current (AC). Does not apply to direct current (DC) circuits.',
    ),

    CalculatorTool(
      id: 'calc_wire_gauge',
      titleEs: 'Calibre de cable eléctrico',
      titleEn: 'Electrical wire gauge',
      tradeId: 'electrical',
      categoryEs: 'Electricidad',
      categoryEn: 'Electrical',
      descriptionEs: 'Determina el calibre AWG mínimo para evitar caída de voltaje.',
      descriptionEn: 'Determine minimum AWG gauge to avoid voltage drop.',
      icon: Icons.cable,
      fields: [
        const CalculatorField(key: 'amps', labelEs: 'Carga en Amperios', labelEn: 'Load in Amps', unitEs: 'A', unitEn: 'A'),
        const CalculatorField(key: 'distance', labelEs: 'Distancia (solo ida)', labelEn: 'Distance (one way)', unitEs: 'ft', unitEn: 'ft'),
        const CalculatorField(
          key: 'volts',
          labelEs: 'Voltaje del circuito',
          labelEn: 'Circuit voltage',
          type: CalculatorFieldType.dropdown,
          optionsEs: ['120V (circuito estándar)', '240V (circuito doble)'],
          optionsEn: ['120V (standard circuit)', '240V (double circuit)'],
        ),
      ],
      calculate: (inputs) {
        final voltageOptions = [120.0, 240.0];
        final volts = voltageOptions[inputs['volts']!.toInt()];
        final cm = (2 * inputs['distance']! * inputs['amps']! * 12.9) / (volts * 0.03);
        double awg;
        double maxAmps;
        if (cm <= 4110)       { awg = 14; maxAmps = 15; }
        else if (cm <= 6530)  { awg = 12; maxAmps = 20; }
        else if (cm <= 10380) { awg = 10; maxAmps = 30; }
        else if (cm <= 16510) { awg =  8; maxAmps = 40; }
        else if (cm <= 26240) { awg =  6; maxAmps = 55; }
        else if (cm <= 41740) { awg =  4; maxAmps = 70; }
        else if (cm <= 66360) { awg =  2; maxAmps = 95; }
        else                  { awg =  1; maxAmps = 110; }
        return {'awg': awg, 'max_amps': maxAmps};
      },
      resultTemplateEs: 'Calibre mínimo: {awg} AWG\nCapacidad máx: {max_amps} A',
      resultTemplateEn: 'Minimum gauge: {awg} AWG\nMax capacity: {max_amps} A',
      resultExplanationEs: 'Basado en caída de voltaje máxima del 3% (NEC recomendado). Usa un calibre mayor (número menor) para más seguridad.',
      resultExplanationEn: 'Based on 3% max voltage drop (NEC recommended). Use a larger gauge (lower number) for added safety.',
      shoppingItemsEs: ['Cable Romex del calibre indicado', 'Breaker del amperaje correcto', 'Conectores / wire nuts', 'Caja eléctrica', 'Cable staples'],
      shoppingItemsEn: ['Romex wire of indicated gauge', 'Correct amperage breaker', 'Wire connectors / wire nuts', 'Electrical box', 'Cable staples'],
      disclaimerEs: 'Cálculo orientativo. Toda instalación eléctrica debe cumplir el código NEC local y ser inspeccionada por un electricista certificado.',
      disclaimerEn: 'For guidance only. All electrical work must comply with local NEC code and be inspected by a licensed electrician.',
    ),

    // ── EXTERIOR / OUTDOOR ──────────────────────────────────────────────────
    CalculatorTool(
      id: 'calc_fence',
      titleEs: 'Materiales para cerca',
      titleEn: 'Fence materials',
      tradeId: 'handyman',
      categoryEs: 'Exterior',
      categoryEn: 'Outdoor',
      descriptionEs: 'Calcula paneles, postes y bolsas de cemento para una cerca.',
      descriptionEn: 'Calculate panels, posts, and concrete bags for a fence.',
      icon: Icons.fence,
      fields: [
        const CalculatorField(key: 'total_length', labelEs: 'Largo total de la cerca', labelEn: 'Total fence length', unitEs: 'ft', unitEn: 'ft'),
        const CalculatorField(
          key: 'panel_width',
          labelEs: 'Ancho del panel',
          labelEn: 'Panel width',
          type: CalculatorFieldType.dropdown,
          optionsEs: ['6 ft por panel', '8 ft por panel'],
          optionsEn: ['6 ft per panel', '8 ft per panel'],
          defaultValue: 1,
        ),
        const CalculatorField(key: 'post_depth', labelEs: 'Profundidad de hoyos', labelEn: 'Post hole depth', unitEs: 'in', unitEn: 'in', defaultValue: 24),
      ],
      calculate: (inputs) {
        final panelWidth = inputs['panel_width']!.toInt() == 0 ? 6.0 : 8.0;
        final length = inputs['total_length']!;
        final postDepth = inputs['post_depth']!;
        final panels = (length / panelWidth).ceil().toDouble();
        final posts = panels + 1;
        final bagsPerPost = postDepth <= 24 ? 1.0 : 2.0;
        final concreteBags = (posts * bagsPerPost).ceil().toDouble();
        return {'panels': panels, 'posts': posts, 'concrete_bags': concreteBags};
      },
      resultTemplateEs: 'Paneles: {panels}\nPostes: {posts}\nBolsas de cemento: {concrete_bags}',
      resultTemplateEn: 'Panels: {panels}\nPosts: {posts}\nConcrete bags: {concrete_bags}',
      shoppingItemsEs: ['Paneles de cerca', 'Postes de madera 4×4 o aluminio', 'Bolsas de cemento Quikrete', 'Herrajes / brackets', 'Tornillos para exterior', 'Nivel de burbuja'],
      shoppingItemsEn: ['Fence panels', '4×4 wood or aluminum posts', 'Quikrete concrete bags', 'Brackets/hardware', 'Exterior screws', 'Bubble level'],
      disclaimerEs: 'Basado en paneles prefabricados estándar. Para cercas de madera a medida, los materiales varían.',
      disclaimerEn: 'Based on standard prefab panels. For custom wood fences, materials will vary.',
    ),

    CalculatorTool(
      id: 'calc_mulch',
      titleEs: 'Mulch o grava',
      titleEn: 'Mulch or gravel',
      tradeId: 'landscaping',
      categoryEs: 'Exterior',
      categoryEn: 'Outdoor',
      descriptionEs: 'Calcula yards cúbicos y bolsas de mulch para camas de jardín.',
      descriptionEn: 'Calculate cubic yards and bags of mulch for garden beds.',
      icon: Icons.grass,
      fields: [
        const CalculatorField(key: 'length', labelEs: 'Largo del área', labelEn: 'Area length', unitEs: 'ft', unitEn: 'ft'),
        const CalculatorField(key: 'width', labelEs: 'Ancho del área', labelEn: 'Area width', unitEs: 'ft', unitEn: 'ft'),
        const CalculatorField(key: 'depth', labelEs: 'Profundidad / grosor', labelEn: 'Depth / thickness', unitEs: 'in', unitEn: 'in', defaultValue: 3),
      ],
      calculate: (inputs) {
        final cuFt = inputs['length']! * inputs['width']! * (inputs['depth']! / 12);
        final cuYards = cuFt / 27;
        final bags2cf = (cuFt / 2).ceil().toDouble();
        return {'cu_yards': cuYards, 'bags_2cf': bags2cf};
      },
      resultTemplateEs: 'Yards cúbicos: {cu_yards} yd³\nBolsas de 2 cu ft: {bags_2cf}',
      resultTemplateEn: 'Cubic yards: {cu_yards} yd³\nBags (2 cu ft each): {bags_2cf}',
      resultExplanationEs: 'Profundidad recomendada: 2-4 in para mulch orgánico, 2-3 in para grava.',
      resultExplanationEn: 'Recommended depth: 2-4 in for organic mulch, 2-3 in for gravel.',
      shoppingItemsEs: ['Mulch o grava (bolsas o por yarda)', 'Tela antimalezas / weed barrier', 'Grapas para tela', 'Guantes de trabajo', 'Rastrillo'],
      shoppingItemsEn: ['Mulch or gravel (bags or bulk)', 'Weed barrier fabric', 'Fabric staples', 'Work gloves', 'Rake'],
    ),

    CalculatorTool(
      id: 'calc_roof',
      titleEs: 'Área del techo',
      titleEn: 'Roof area',
      tradeId: 'roofing',
      categoryEs: 'Exterior',
      categoryEn: 'Outdoor',
      descriptionEs: 'Calcula squares y bundles de material de techo según footprint y pitch.',
      descriptionEn: 'Calculate roofing squares and bundles based on footprint and pitch.',
      icon: Icons.roofing,
      fields: [
        const CalculatorField(key: 'length', labelEs: 'Largo de la estructura', labelEn: 'Structure length', unitEs: 'ft', unitEn: 'ft'),
        const CalculatorField(key: 'width', labelEs: 'Ancho de la estructura', labelEn: 'Structure width', unitEs: 'ft', unitEn: 'ft'),
        const CalculatorField(
          key: 'pitch',
          labelEs: 'Pitch del techo',
          labelEn: 'Roof pitch',
          type: CalculatorFieldType.dropdown,
          optionsEs: ['4/12 (bajo / Florida)', '6/12 (medio)', '8/12 (moderado)', '10/12 (inclinado)', '12/12 (empinado)'],
          optionsEn: ['4/12 (low / Florida)', '6/12 (medium)', '8/12 (moderate)', '10/12 (steep)', '12/12 (very steep)'],
        ),
      ],
      calculate: (inputs) {
        const pitchMultipliers = [1.054, 1.118, 1.202, 1.302, 1.414];
        final multiplier = pitchMultipliers[inputs['pitch']!.toInt()];
        final footprint = inputs['length']! * inputs['width']!;
        final slopedArea = footprint * multiplier;
        final squares = slopedArea / 100;
        final bundles = (squares * 3 * 1.10).ceil().toDouble();
        return {'sloped_area': slopedArea, 'squares': squares, 'bundles': bundles};
      },
      resultTemplateEs: 'Área inclinada: {sloped_area} sq ft\nSquares: {squares}\nBundles (+10%): {bundles}',
      resultTemplateEn: 'Sloped area: {sloped_area} sq ft\nSquares: {squares}\nBundles (+10%): {bundles}',
      resultExplanationEs: '1 roofing square = 100 sq ft. 1 square = 3 bundles de shingles.',
      resultExplanationEn: '1 roofing square = 100 sq ft. 1 square = 3 bundles of shingles.',
      shoppingItemsEs: ['Shingles (bundles calculados)', 'Underlayment (roofing felt)', 'Clavos para techo', 'Ridge cap shingles', 'Starter strip', 'Flashing de metal'],
      shoppingItemsEn: ['Shingles (calculated bundles)', 'Underlayment (roofing felt)', 'Roofing nails', 'Ridge cap shingles', 'Starter strip', 'Metal flashing'],
      disclaimerEs: 'Cálculo para techo a dos aguas (gable). Para techos con múltiples vertientes, calcula cada sección por separado.',
      disclaimerEn: 'Calculation for simple gable roof. For multi-slope roofs, calculate each section separately.',
    ),

    // ── HVAC ────────────────────────────────────────────────────────────────
    CalculatorTool(
      id: 'calc_btu',
      titleEs: 'BTU para aire acondicionado',
      titleEn: 'BTU for air conditioning',
      tradeId: 'hvac',
      categoryEs: 'HVAC',
      categoryEn: 'HVAC',
      descriptionEs: 'Calcula los BTU necesarios para enfriar un espacio correctamente.',
      descriptionEn: 'Calculate the BTUs needed to cool a space correctly.',
      icon: Icons.ac_unit,
      fields: [
        const CalculatorField(key: 'length', labelEs: 'Largo del cuarto', labelEn: 'Room length', unitEs: 'ft', unitEn: 'ft'),
        const CalculatorField(key: 'width', labelEs: 'Ancho del cuarto', labelEn: 'Room width', unitEs: 'ft', unitEn: 'ft'),
        const CalculatorField(key: 'height', labelEs: 'Altura del techo', labelEn: 'Ceiling height', unitEs: 'ft', unitEn: 'ft', defaultValue: 8),
        const CalculatorField(
          key: 'climate',
          labelEs: 'Clima de la región',
          labelEn: 'Regional climate',
          type: CalculatorFieldType.dropdown,
          optionsEs: ['Moderado (zona 3-4)', 'Caliente (zona 5-6, ej. Texas)', 'Muy caliente (zona 7+, ej. Florida, AZ)'],
          optionsEn: ['Moderate (zone 3-4)', 'Hot (zone 5-6, e.g. Texas)', 'Very hot (zone 7+, e.g. Florida, AZ)'],
          defaultValue: 2,
        ),
      ],
      calculate: (inputs) {
        const climateFactors = [1.0, 1.15, 1.30];
        final factor = climateFactors[inputs['climate']!.toInt()];
        final area = inputs['length']! * inputs['width']!;
        final heightFactor = inputs['height']! / 8.0;
        final btu = area * 20 * heightFactor * factor;
        final tons = btu / 12000;
        return {'btu': btu, 'tons': tons};
      },
      resultTemplateEs: 'BTU necesarios: {btu}\nToneladas de A/C: {tons} ton',
      resultTemplateEn: 'BTUs needed: {btu}\nA/C tonnage: {tons} ton',
      resultExplanationEs: 'Basado en 20 BTU/sq ft. Para espacios muy soleados o con muchas personas, suma 10% adicional.',
      resultExplanationEn: 'Based on 20 BTU/sq ft. For very sunny spaces or heavy occupancy, add 10% more.',
      shoppingItemsEs: ['Unidad de A/C (tonelaje calculado)', 'Filtro de aire 1"', 'Termostato programable', 'Aislamiento de ductos'],
      shoppingItemsEn: ['A/C unit (calculated tonnage)', '1" air filter', 'Programmable thermostat', 'Duct insulation'],
      disclaimerEs: 'Estimado para uso residencial estándar. Consulta un técnico HVAC para edificios comerciales o con poca aislación.',
      disclaimerEn: 'Estimate for standard residential use. Consult an HVAC technician for commercial buildings or poorly insulated spaces.',
    ),

    // ── PISCINA / POOL ──────────────────────────────────────────────────────
    CalculatorTool(
      id: 'calc_pool_chlorine',
      titleEs: 'Cloro para piscina',
      titleEn: 'Pool chlorine dosing',
      tradeId: 'pool',
      categoryEs: 'Piscina',
      categoryEn: 'Pool',
      descriptionEs: 'Calcula cuánto cloro agregar para alcanzar el nivel deseado.',
      descriptionEn: 'Calculate how much chlorine to add to reach the desired level.',
      icon: Icons.science,
      fields: [
        const CalculatorField(key: 'pool_gallons', labelEs: 'Volumen de la piscina', labelEn: 'Pool volume', unitEs: 'gal', unitEn: 'gal', defaultValue: 15000),
        const CalculatorField(key: 'current_ppm', labelEs: 'Cloro libre actual', labelEn: 'Current free chlorine', unitEs: 'ppm', unitEn: 'ppm', defaultValue: 0),
        const CalculatorField(key: 'target_ppm', labelEs: 'Cloro objetivo', labelEn: 'Target chlorine', unitEs: 'ppm', unitEn: 'ppm', defaultValue: 3),
        const CalculatorField(
          key: 'product',
          labelEs: 'Tipo de producto',
          labelEn: 'Product type',
          type: CalculatorFieldType.dropdown,
          optionsEs: ['Shock granular 65% (cal-hypo)', 'Dichlor granular 56%', 'Cloro líquido 10% (bleach)'],
          optionsEn: ['Granular shock 65% (cal-hypo)', 'Dichlor granular 56%', 'Liquid chlorine 10% (bleach)'],
        ),
      ],
      calculate: (inputs) {
        final delta = (inputs['target_ppm']! - inputs['current_ppm']!).clamp(0.0, 100.0);
        const strengths = [0.65, 0.56, 0.10];
        final strength = strengths[inputs['product']!.toInt()];
        final lbs = (delta * inputs['pool_gallons']! * 0.0000834) / strength;
        final oz = lbs * 16;
        return {'oz': oz, 'lbs': lbs};
      },
      resultTemplateEs: 'Cantidad a agregar: {oz} oz\n({lbs} lbs)',
      resultTemplateEn: 'Amount to add: {oz} oz\n({lbs} lbs)',
      resultExplanationEs: 'Para tratamiento Shock completo (algas): usa el doble de la cantidad calculada.',
      resultExplanationEn: 'For full Shock treatment (algae): use double the calculated amount.',
      shoppingItemsEs: ['Cloro / Shock (bolsa o galón)', 'Kit de prueba pH y cloro', 'Cepillo de piscina', 'Red / skimmer net'],
      shoppingItemsEn: ['Chlorine / Shock (bag or gallon)', 'pH and chlorine test kit', 'Pool brush', 'Skimmer net'],
      disclaimerEs: 'Añade siempre los químicos al agua (no al revés). No nades hasta que el cloro baje a 3 ppm o menos. Usa guantes y gafas.',
      disclaimerEn: 'Always add chemicals to water (not reverse). Do not swim until chlorine drops to 3 ppm or less. Use gloves and goggles.',
    ),
  ];

  static List<String> getCategories(String lang) {
    if (lang == 'en') {
      return ['All', 'Painting', 'Flooring', 'Construction', 'Electrical', 'Outdoor', 'HVAC', 'Pool'];
    }
    return ['Todos', 'Pintura', 'Pisos', 'Construcción', 'Electricidad', 'Exterior', 'HVAC', 'Piscina'];
  }
}
