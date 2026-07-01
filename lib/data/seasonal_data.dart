import 'package:flutter/material.dart';
import '../models/seasonal_checklist.dart';

class SeasonalData {
  static Season get currentSeason {
    final m = DateTime.now().month;
    if (m >= 3 && m <= 5) return Season.spring;
    if (m >= 6 && m <= 8) return Season.summer;
    if (m >= 9 && m <= 11) return Season.fall;
    return Season.winter;
  }

  static List<SeasonalTask> tasksFor(Season s) {
    switch (s) {
      case Season.spring: return _spring;
      case Season.summer: return _summer;
      case Season.fall:   return _fall;
      case Season.winter: return _winter;
    }
  }

  static Color colorFor(Season s) {
    switch (s) {
      case Season.spring: return const Color(0xFF2E7D32);
      case Season.summer: return const Color(0xFFE65100);
      case Season.fall:   return const Color(0xFF6D4C41);
      case Season.winter: return const Color(0xFF1565C0);
    }
  }

  static String emojiFor(Season s) {
    switch (s) {
      case Season.spring: return '🌸';
      case Season.summer: return '☀️';
      case Season.fall:   return '🍂';
      case Season.winter: return '❄️';
    }
  }

  static String nameEs(Season s) {
    switch (s) {
      case Season.spring: return 'Primavera';
      case Season.summer: return 'Verano';
      case Season.fall:   return 'Otoño';
      case Season.winter: return 'Invierno';
    }
  }

  static String nameEn(Season s) {
    switch (s) {
      case Season.spring: return 'Spring';
      case Season.summer: return 'Summer';
      case Season.fall:   return 'Fall';
      case Season.winter: return 'Winter';
    }
  }

  // ── PRIMAVERA / SPRING ────────────────────────────────────────────────────

  static const List<SeasonalTask> _spring = [
    SeasonalTask(
      id: 'spr_roof_inspect',
      categoryEs: 'Techo', categoryEn: 'Roof',
      titleEs: 'Inspeccionar el techo por daños de invierno (tejas sueltas, grietas)',
      titleEn: 'Inspect roof for winter damage (loose shingles, cracks)',
      isHighPriority: true,
    ),
    SeasonalTask(
      id: 'spr_gutter_clean',
      categoryEs: 'Techo', categoryEn: 'Roof',
      titleEs: 'Limpiar canaletas y bajantes de debris acumulado',
      titleEn: 'Clean gutters and downspouts of accumulated debris',
      isHighPriority: true,
    ),
    SeasonalTask(
      id: 'spr_deck_inspect',
      categoryEs: 'Exterior', categoryEn: 'Exterior',
      titleEs: 'Inspeccionar deck/terraza: madera podrida, clavos sueltos, barandales',
      titleEn: 'Inspect deck/patio: rotted wood, loose nails, railings',
    ),
    SeasonalTask(
      id: 'spr_seal_exterior',
      categoryEs: 'Exterior', categoryEn: 'Exterior',
      titleEs: 'Sellar grietas en fundación, aceras y paredes exteriores',
      titleEn: 'Seal cracks in foundation, sidewalks and exterior walls',
    ),
    SeasonalTask(
      id: 'spr_window_screens',
      categoryEs: 'Exterior', categoryEn: 'Exterior',
      titleEs: 'Limpiar y colocar mosquiteros en ventanas y puertas',
      titleEn: 'Clean and install window and door screens',
    ),
    SeasonalTask(
      id: 'spr_paint_exterior',
      categoryEs: 'Exterior', categoryEn: 'Exterior',
      titleEs: 'Repintar o resellar madera exterior expuesta (marcos, puertas, fascia)',
      titleEn: 'Repaint or reseal exposed exterior wood (frames, doors, fascia)',
    ),
    SeasonalTask(
      id: 'spr_ac_filter',
      categoryEs: 'HVAC', categoryEn: 'HVAC',
      titleEs: 'Cambiar filtros del A/C antes de la temporada de calor',
      titleEn: 'Replace A/C filters before the hot season',
      isHighPriority: true,
    ),
    SeasonalTask(
      id: 'spr_ac_service',
      categoryEs: 'HVAC', categoryEn: 'HVAC',
      titleEs: 'Programar mantenimiento anual del sistema de A/C con técnico',
      titleEn: 'Schedule annual A/C system maintenance with a technician',
    ),
    SeasonalTask(
      id: 'spr_sprinkler',
      categoryEs: 'Jardín', categoryEn: 'Lawn & Garden',
      titleEs: 'Activar y revisar el sistema de riego: cabezas, fugas, programación',
      titleEn: 'Activate and inspect irrigation system: heads, leaks, programming',
    ),
    SeasonalTask(
      id: 'spr_lawn_fertilize',
      categoryEs: 'Jardín', categoryEn: 'Lawn & Garden',
      titleEs: 'Fertilizar el césped y resembrar áreas peladas',
      titleEn: 'Fertilize lawn and overseed bare spots',
    ),
    SeasonalTask(
      id: 'spr_prune',
      categoryEs: 'Jardín', categoryEn: 'Lawn & Garden',
      titleEs: 'Podar árboles y arbustos para estimular crecimiento primaveral',
      titleEn: 'Prune trees and shrubs to stimulate spring growth',
    ),
    SeasonalTask(
      id: 'spr_smoke_detector',
      categoryEs: 'Seguridad', categoryEn: 'Safety',
      titleEs: 'Cambiar baterías de detectores de humo y monóxido de carbono',
      titleEn: 'Replace batteries in smoke and carbon monoxide detectors',
      isHighPriority: true,
    ),
    SeasonalTask(
      id: 'spr_dryer_vent',
      categoryEs: 'Seguridad', categoryEn: 'Safety',
      titleEs: 'Limpiar el ducto del secador (pelusa acumulada = riesgo de incendio)',
      titleEn: 'Clean dryer vent duct (lint buildup = fire hazard)',
      isHighPriority: true,
    ),
  ];

  // ── VERANO / SUMMER ───────────────────────────────────────────────────────

  static const List<SeasonalTask> _summer = [
    SeasonalTask(
      id: 'sum_deck_seal',
      categoryEs: 'Exterior', categoryEn: 'Exterior',
      titleEs: 'Sellar o barnizar el deck si no se hizo en primavera',
      titleEn: 'Seal or stain deck if not done in spring',
    ),
    SeasonalTask(
      id: 'sum_fence_inspect',
      categoryEs: 'Exterior', categoryEn: 'Exterior',
      titleEs: 'Inspeccionar la cerca: postes sueltos, madera podrida, paneles caídos',
      titleEn: 'Inspect fence: loose posts, rotted wood, fallen panels',
    ),
    SeasonalTask(
      id: 'sum_outdoor_electrical',
      categoryEs: 'Exterior', categoryEn: 'Exterior',
      titleEs: 'Revisar tomas e iluminación exterior por corrosión o daño',
      titleEn: 'Check outdoor outlets and lighting for corrosion or damage',
    ),
    SeasonalTask(
      id: 'sum_ac_efficiency',
      categoryEs: 'HVAC', categoryEn: 'HVAC',
      titleEs: 'Verificar que el A/C enfría correctamente; limpiar condensador exterior',
      titleEn: 'Verify A/C cools properly; clean exterior condenser unit',
      isHighPriority: true,
    ),
    SeasonalTask(
      id: 'sum_attic_ventilation',
      categoryEs: 'HVAC', categoryEn: 'HVAC',
      titleEs: 'Verificar ventilación del ático para reducir acumulación de calor',
      titleEn: 'Verify attic ventilation to reduce heat buildup',
    ),
    SeasonalTask(
      id: 'sum_ceiling_fans',
      categoryEs: 'Interior', categoryEn: 'Interior',
      titleEs: 'Asegurar que ventiladores de techo giran anti-horario (efecto frío)',
      titleEn: 'Ensure ceiling fans rotate counter-clockwise (cooling effect)',
    ),
    SeasonalTask(
      id: 'sum_window_seal',
      categoryEs: 'Interior', categoryEn: 'Interior',
      titleEs: 'Revisar sellos de ventanas para evitar pérdida del A/C',
      titleEn: 'Check window seals to prevent A/C loss',
    ),
    SeasonalTask(
      id: 'sum_irrigation_adjust',
      categoryEs: 'Jardín', categoryEn: 'Lawn & Garden',
      titleEs: 'Ajustar horario del sistema de riego según temperatura y lluvias',
      titleEn: 'Adjust irrigation schedule based on temperature and rainfall',
    ),
    SeasonalTask(
      id: 'sum_pool_check',
      categoryEs: 'Jardín', categoryEn: 'Lawn & Garden',
      titleEs: 'Revisar niveles de cloro, pH y filtros de la piscina semanalmente',
      titleEn: 'Check pool chlorine, pH levels and filters weekly',
    ),
    SeasonalTask(
      id: 'sum_tree_trim',
      categoryEs: 'Jardín', categoryEn: 'Lawn & Garden',
      titleEs: 'Podar ramas que cuelgan sobre el techo, aceras o cables eléctricos',
      titleEn: 'Trim branches hanging over roof, walkways or power lines',
      isHighPriority: true,
    ),
    SeasonalTask(
      id: 'sum_sump_pump',
      categoryEs: 'Seguridad', categoryEn: 'Safety',
      titleEs: 'Probar el sump pump antes de temporada de lluvias de verano',
      titleEn: 'Test sump pump before summer rain season',
    ),
    SeasonalTask(
      id: 'sum_garage_door_lube',
      categoryEs: 'Seguridad', categoryEn: 'Safety',
      titleEs: 'Lubricar bisagras, rieles y resortes de la puerta del garaje',
      titleEn: 'Lubricate garage door hinges, tracks and springs',
    ),
  ];

  // ── OTOÑO / FALL ─────────────────────────────────────────────────────────

  static const List<SeasonalTask> _fall = [
    SeasonalTask(
      id: 'fal_roof_inspect',
      categoryEs: 'Techo', categoryEn: 'Roof',
      titleEs: 'Inspeccionar el techo antes del invierno: tejas, sellos, botas de chimenea',
      titleEn: 'Inspect roof before winter: shingles, seals, chimney flashing',
      isHighPriority: true,
    ),
    SeasonalTask(
      id: 'fal_gutter_clean',
      categoryEs: 'Techo', categoryEn: 'Roof',
      titleEs: 'Limpiar canaletas nuevamente después de la caída de hojas',
      titleEn: 'Clean gutters again after leaves have fallen',
      isHighPriority: true,
    ),
    SeasonalTask(
      id: 'fal_heater_filter',
      categoryEs: 'HVAC', categoryEn: 'HVAC',
      titleEs: 'Cambiar filtros del sistema de calefacción (furnace) antes del invierno',
      titleEn: 'Replace furnace/heating system filters before winter',
      isHighPriority: true,
    ),
    SeasonalTask(
      id: 'fal_heater_service',
      categoryEs: 'HVAC', categoryEn: 'HVAC',
      titleEs: 'Programar mantenimiento anual del calentador con técnico certificado',
      titleEn: 'Schedule annual furnace maintenance with certified technician',
    ),
    SeasonalTask(
      id: 'fal_chimney_inspect',
      categoryEs: 'HVAC', categoryEn: 'HVAC',
      titleEs: 'Inspeccionar y limpiar la chimenea si se usa en invierno',
      titleEn: 'Inspect and clean fireplace/chimney if used in winter',
    ),
    SeasonalTask(
      id: 'fal_thermostat',
      categoryEs: 'HVAC', categoryEn: 'HVAC',
      titleEs: 'Cambiar el termostato al modo calefacción y programar horarios de invierno',
      titleEn: 'Switch thermostat to heat mode and program winter schedules',
    ),
    SeasonalTask(
      id: 'fal_hose_drain',
      categoryEs: 'Plomería', categoryEn: 'Plumbing',
      titleEs: 'Drenar y guardar las mangueras de jardín para evitar congelamiento',
      titleEn: 'Drain and store garden hoses to prevent freezing',
    ),
    SeasonalTask(
      id: 'fal_irrigation_off',
      categoryEs: 'Plomería', categoryEn: 'Plumbing',
      titleEs: 'Apagar y drenar completamente el sistema de riego/sprinklers',
      titleEn: 'Shut off and fully drain irrigation/sprinkler system',
      isHighPriority: true,
    ),
    SeasonalTask(
      id: 'fal_pipe_insulate',
      categoryEs: 'Plomería', categoryEn: 'Plumbing',
      titleEs: 'Aislar tuberías expuestas en exteriores, garaje o sótano',
      titleEn: 'Insulate exposed pipes in exterior areas, garage or basement',
      isHighPriority: true,
    ),
    SeasonalTask(
      id: 'fal_caulk_seal',
      categoryEs: 'Exterior', categoryEn: 'Exterior',
      titleEs: 'Sellar grietas alrededor de ventanas, puertas y fundación',
      titleEn: 'Caulk gaps around windows, doors and foundation',
    ),
    SeasonalTask(
      id: 'fal_concrete_seal',
      categoryEs: 'Exterior', categoryEn: 'Exterior',
      titleEs: 'Aplicar sellador a aceras y entrada de vehículos antes del frío',
      titleEn: 'Apply sealer to sidewalks and driveway before cold weather',
    ),
    SeasonalTask(
      id: 'fal_detector_battery',
      categoryEs: 'Seguridad', categoryEn: 'Safety',
      titleEs: 'Cambiar baterías de detectores de humo y CO (2 veces al año)',
      titleEn: 'Replace batteries in smoke and CO detectors (twice a year)',
      isHighPriority: true,
    ),
    SeasonalTask(
      id: 'fal_generator_test',
      categoryEs: 'Seguridad', categoryEn: 'Safety',
      titleEs: 'Probar el generador de emergencia y verificar nivel de combustible',
      titleEn: 'Test emergency generator and check fuel level',
    ),
  ];

  // ── INVIERNO / WINTER ─────────────────────────────────────────────────────

  static const List<SeasonalTask> _winter = [
    SeasonalTask(
      id: 'win_pipe_protect',
      categoryEs: 'Plomería', categoryEn: 'Plumbing',
      titleEs: 'Proteger tuberías en áreas no calefaccionadas durante frío extremo',
      titleEn: 'Protect pipes in unheated areas during extreme cold',
      isHighPriority: true,
    ),
    SeasonalTask(
      id: 'win_water_heater',
      categoryEs: 'Plomería', categoryEn: 'Plumbing',
      titleEs: 'Aislar el calentador de agua si está en garaje o sótano frío',
      titleEn: 'Insulate water heater if located in cold garage or basement',
    ),
    SeasonalTask(
      id: 'win_drip_faucets',
      categoryEs: 'Plomería', categoryEn: 'Plumbing',
      titleEs: 'En noches muy frías, dejar gotear ligeramente los grifos exteriores',
      titleEn: 'On very cold nights, let exterior faucets drip slightly',
    ),
    SeasonalTask(
      id: 'win_door_sweep',
      categoryEs: 'Interior', categoryEn: 'Interior',
      titleEs: 'Revisar y reemplazar burletes de puertas exteriores que pierden calor',
      titleEn: 'Inspect and replace door sweeps/weatherstripping on exterior doors',
    ),
    SeasonalTask(
      id: 'win_window_film',
      categoryEs: 'Interior', categoryEn: 'Interior',
      titleEs: 'Colocar film aislante en ventanas para reducir pérdida de calor',
      titleEn: 'Apply insulating film to windows to reduce heat loss',
    ),
    SeasonalTask(
      id: 'win_min_temp',
      categoryEs: 'Interior', categoryEn: 'Interior',
      titleEs: 'Mantener temperatura mínima de 55°F (13°C) aunque nadie esté en casa',
      titleEn: 'Maintain minimum temperature of 55°F (13°C) even when away',
      isHighPriority: true,
    ),
    SeasonalTask(
      id: 'win_heater_monthly',
      categoryEs: 'HVAC', categoryEn: 'HVAC',
      titleEs: 'Revisar el furnace mensualmente; cambiar filtro si está sucio',
      titleEn: 'Check furnace monthly; replace filter if dirty',
    ),
    SeasonalTask(
      id: 'win_space_heater',
      categoryEs: 'HVAC', categoryEn: 'HVAC',
      titleEs: 'Verificar que calentadores portátiles tienen apagado automático',
      titleEn: 'Verify portable space heaters have automatic shut-off',
    ),
    SeasonalTask(
      id: 'win_emergency_kit',
      categoryEs: 'Seguridad', categoryEn: 'Safety',
      titleEs: 'Preparar kit de emergencia: linterna, baterías, agua, frazadas, comida',
      titleEn: 'Prepare emergency kit: flashlight, batteries, water, blankets, food',
      isHighPriority: true,
    ),
    SeasonalTask(
      id: 'win_ice_salt',
      categoryEs: 'Seguridad', categoryEn: 'Safety',
      titleEs: 'Mantener sal o arena para hielo en entrada y escalones exteriores',
      titleEn: 'Keep ice salt or sand for driveway and exterior steps',
    ),
    SeasonalTask(
      id: 'win_co_detector',
      categoryEs: 'Seguridad', categoryEn: 'Safety',
      titleEs: 'Verificar detector de CO (calefacción activa = mayor riesgo)',
      titleEn: 'Check CO detector (active heating = higher risk)',
      isHighPriority: true,
    ),
    SeasonalTask(
      id: 'win_fire_extinguisher',
      categoryEs: 'Seguridad', categoryEn: 'Safety',
      titleEs: 'Revisar el extintor (especialmente si usas chimenea esta temporada)',
      titleEn: 'Inspect fire extinguisher (especially if using fireplace this season)',
    ),
    SeasonalTask(
      id: 'win_sump_pump_check',
      categoryEs: 'Exterior', categoryEn: 'Exterior',
      titleEs: 'Revisar sump pump para el deshielo de primavera que se acerca',
      titleEn: 'Check sump pump for upcoming spring snowmelt',
    ),
    SeasonalTask(
      id: 'win_roof_snow',
      categoryEs: 'Exterior', categoryEn: 'Exterior',
      titleEs: 'Retirar nieve excesiva del techo si supera 12" (riesgo de colapso)',
      titleEn: 'Remove excessive roof snow if over 12" (collapse risk)',
      isHighPriority: true,
    ),
  ];
}
