const initialState = {
  isReady: false,
  isLoggedIn: false,
  name: null,
  playerId: null,
  profileImageUrl: null,
};

const playerSession = (state = initialState, action) => {
  const payload = action.payload;

  switch (action.type) {
    case 'FETCH_PLAYER_SUCCEEDED':
      return {
        ...state,
        isReady: true,
        isLoggedIn: true,
        name: action.name,
        playerId: action.playerId,
        profileImageUrl: action.profileImageUrl,
      };
    case 'FETCH_PLAYER_FAILED':
      return { ...state, isReady: true };
    case 'UPDATE_PLAYER_SUCCEEDED':
      return {
        ...state,
        name: payload.updatedPlayer.name,
        playerId: payload.updatedPlayer.playerId,
        profileImageUrl: payload.updatedPlayer.profileImageUrl,
      };
    default:
      return state;
  }
};

export default playerSession;
