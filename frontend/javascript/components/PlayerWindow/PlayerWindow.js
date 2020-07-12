import React from 'react';
import classNames from 'classnames';
import PropTypes from 'prop-types';
import { useSelector } from 'react-redux';

import Box from '@material-ui/core/Box';
import Button from '@material-ui/core/Button';
import MicOffIcon from '@material-ui/icons/MicOff';
import MicIcon from '@material-ui/icons/Mic';
import VideocamOffIcon from '@material-ui/icons/VideocamOff';
import VideocamIcon from '@material-ui/icons/Videocam';
import { nameByActionType } from 'helpers/actionType';

import PlayerAvatarWindow from './components/PlayerAvatarWindow';
import usePlayerWindow from './hooks/usePlayerWindow';
import useStyles from './PlayerWindowStyles';

const PlayerWindow = ({ player, isTurn }) => {
  const classes = useStyles({ player });
  const videoState = useSelector(state => state.data.video);
  const { playerId } = useSelector(state => state.data.playerSession);
  const { enableAudio, disableAudio, enableVideo, disableVideo } = usePlayerWindow(player);

  const isVideoDistributor = playerId => !!videoState.streamByPlayerId[playerId];

  if (!player) return null;
  const isMe = playerId === player.id;

  return (
    <div className={classNames(classes.container, { [classes.isTurn]: isTurn })}>
      {isVideoDistributor(player.id) ? (
        <div className={classes.videoContainer}>
          <video id={`video-player-${player.id}`} playsInline autoPlay className={classes.video} />
          {!videoState.isVideoEnabledByPlayerId[player.id] && player.imageUrl && (
            <img src={player.imageUrl} alt={player.nickname} className={classes.avatar} />
          )}
          <span className={classes.nickname}>{player.nickname}</span>
          <span className={classes.status}>
            {player.actionType ? (
              <div className={classes.actionType}>{nameByActionType[player.actionType]}</div>
            ) : player.stack - (player.betSize || 0) === 0 ? (
              <div className={classes.allin}>オールイン</div>
            ) : (
              <div className={classes.stackSize}>{player.stack - (player.betSize || 0)}</div>
            )}
          </span>
          {isMe && (
            <div className={classes.inner}>
              <Box mb={2}>
                {videoState.isVideoEnabledByPlayerId[player.id] ? (
                  <Button className={classes.micSwitchButton} startIcon={<VideocamIcon />} onClick={disableVideo}>
                    ビデオをOFFにする
                  </Button>
                ) : (
                  <Button className={classes.micSwitchButton} startIcon={<VideocamOffIcon />} onClick={enableVideo}>
                    ビデオをONにする
                  </Button>
                )}
              </Box>
              {videoState.isAudioEnabledByPlayerId[player.id] ? (
                <Button className={classes.micSwitchButton} startIcon={<MicIcon />} onClick={disableAudio}>
                  マイクをOFFにする
                </Button>
              ) : (
                <Button className={classes.micSwitchButton} startIcon={<MicOffIcon />} onClick={enableAudio}>
                  マイクをONにする
                </Button>
              )}
            </div>
          )}
          {isMe && !videoState.isAudioEnabledByPlayerId[player.id] && <MicOffIcon className={classes.micOffIcon} />}
        </div>
      ) : (
        <PlayerAvatarWindow player={player} isMe={isMe} />
      )}
    </div>
  );
};

PlayerWindow.propTypes = {
  player: PropTypes.object.isRequired,
  isTurn: PropTypes.bool,
};

PlayerWindow.defaultProps = {
  isTurn: false,
};

export default PlayerWindow;
