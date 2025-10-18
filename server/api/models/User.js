const Roles = {
  ADMIN: 'admin',
  USER: 'user',
};

const Profiles = {
  VENDEDOR: 'vendedor',
  INDICADOR: 'indicador',
  ADMIN: 'admin',
};

module.exports = {
  Roles,
  Profiles,

  attributes: {
    id: {
      type: 'string',
      columnName: 'id',
    },
    email: {
      type: 'string',
      required: true,
      unique: true,
      isEmail: true,
    },
    password: {
      type: 'string',
      allowNull: true,
    },
    role: {
      type: 'string',
      isIn: Object.values(Roles),
      required: true,
    },
    name: {
      type: 'string',
      required: true,
    },
    avatarUrl: {
      type: 'string',
      isNotEmptyString: true,
      allowNull: true,
      columnName: 'avatar_url',
    },
    isEmailConfirmed: {
      type: 'boolean',
      defaultsTo: false,
      columnName: 'is_email_confirmed',
    },
    companyId: {
      model: 'Company',
      columnName: 'company_id',
    },
    perfil: {
      type: 'string',
      isIn: Object.values(Profiles),
      defaultsTo: Profiles.VENDEDOR,
    },
    company: {
      model: 'Company',
    },
    chatMessages: {
      collection: 'CardsChat',
      via: 'userId',
    },
  },

  tableName: 'user_account',
};
