const formatTime = (seconds: number): string => {
  if (seconds <= 0) {
    return '0 сек.';
  }
  const minutes = Math.floor(seconds / 60);
  const remainingSeconds = Math.round(seconds % 60);
  if (minutes > 0) {
    return `${minutes} мин. ${remainingSeconds} сек.`;
  }
  return `${remainingSeconds} сек.`;
};

export default {
  windowTitle: 'My Wombs',
  emptyState: 'Репродуктивные органы не обнаружены.',
  tabs: {
    eggs: 'Яйца',
    settings: 'Настройки',
    genetics: 'Генетика',
  },
  labels: {
    organ: 'ОРГАН',
    eggsInside: 'ЯЙЦА ВНУТРИ',
    stored: 'Запас',
    clutch: 'Кладка',
    capacity: 'Вместимость',
    color: 'Цвет',
    type: 'Тип',
    name: 'Имя',
    description: 'Описание',
    organDescription: 'Описание органа',
    nutrients: 'Питание',
    nutrientCost: 'Затраты',
    interval: 'Интервал',
    resourceDependent: 'Зависит от ресурсов',
    limit: 'Лимит',
    production: 'Производство',
    nextEgg: 'Следующее яйцо',
    hatchlingsInside: 'Детенышей внутри',
    stage: 'Стадия',
    scale: 'Размер',
    traits: 'Свойства',
    preview: 'Предпросмотр',
    parents: 'Родители',
    mother: 'Мать',
    father: 'Отец',
    unknown: 'Неизвестно',
    defaultColor: 'По умолчанию',
    fertilized: 'Оплодотворено',
    unfertilized: 'Не оплодотворено',
    by: 'от',
    autoHatch: 'Автовылупление',
    internalBirth: 'Внутреннее рождение',
    willHatchInside: 'Вылупится внутри носителя.',
    extract: 'Извлечь',
    extractAll: 'Извлечь яйца',
    layEggs: 'Отложить яйца',
    edit: 'Изменить',
    pickColor: 'Выбрать цвет',
    apply: 'Применить',
    reset: 'Сброс',
    profileDefault: 'Профиль',
    on: 'ВКЛ',
    off: 'ВЫКЛ',
    active: 'Активно',
    inactive: 'Неактивно',
    yes: 'Да',
    no: 'Нет',
    unknownStage: '-',
  },
  organNames: {
    ovipositor: 'ЯЙЦЕКЛАД',
    womb: 'МАТКА',
    anus: 'АНУС',
    guts: 'ЖИВОТ',
  },
  eggTypes: {
    Hardshell: 'Твердоскорлупное',
    Avian: 'Птичье',
    Softshell: 'Мягкоскорлупное',
    Parasitic: 'Паразитическое',
    Spider: 'Паучье',
    'Bog Bug': 'Болотного жука',
    Harpy: 'Гарпии',
    Embryo: 'Детеныш',
  },
  traitNames: {
    Aphrodisiac: 'Афродизиак',
    Poison: 'Яд',
    Parasite: 'Паразит',
    Accelerated: 'Ускоренное развитие',
    aphrodisiac: 'Афродизиак',
    poison: 'Яд',
    parasite: 'Паразит',
    fast_growth: 'Ускоренное развитие',
  },
  formatTime,
  formatStatus: (status: string, timeLeft: number): string => {
    if (status === 'ready') {
      return 'Готово.';
    }
    if (status === 'growing') {
      if (timeLeft > 0) {
        return `Готово через ${formatTime(timeLeft)}.`;
      }
      return 'Растет.';
    }
    return 'Спит.';
  },
};
