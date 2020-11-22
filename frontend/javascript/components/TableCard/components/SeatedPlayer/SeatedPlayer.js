import React from 'react';
import PropTypes from 'prop-types';
import Avatar from '@material-ui/core/Avatar';
import useStyles from './SeatedPlayerStyles';

const SeatedPlayer = ({ player }) => {
  const classes = useStyles(player);

  return (
    <div className={classes.player}>
      <Avatar src={player.profileImageUrl} alt={player.name} />
    </div>
  );
};

SeatedPlayer.propTypes = {
  player: PropTypes.object.isRequired,
};

export default SeatedPlayer;
