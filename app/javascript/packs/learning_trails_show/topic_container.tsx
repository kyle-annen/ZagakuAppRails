import * as React from 'react';

import Level from './level'
import Api from "../../utils/api";

export interface TopicContainerProps {
  id: number,
  api: any
}

export interface TopicContainerState {
  topic_id: number,
  topic_data: object,
  user_lessons: object,
  api: Api
}

export default class TopicContainer
  extends React.Component<TopicContainerProps, TopicContainerState> {
  constructor(props){
    super(props);
    this.state = {
      topic_id: this.props.id,
      topic_data: {},
      user_lessons: {},
      api: this.props.api,
    }
  }

  componentDidMount() {
    this.state.api.get('topic', this.props.id, this.setData);
  }

  setData (result) {
    this.setState({
      topic_data: result.topic,
      user_lessons: result.user_lessons
    })
  };

  renderLevels() {
    const level_keys = Object.keys(this.state.user_lessons);
    return level_keys.map((key) => {
      return <Level level={key}
                    tasks={this.state.user_lessons[key].tasks}
                    goals={this.state.user_lessons[key].goals}
                    references={this.state.user_lessons[key].references}
                    key={key} />;
    });
  }

  render() {

    return(
      <div className="container">
        <h2 className="topic-page-summary">Test Title</h2>
        <p>Test content</p>
        { this.renderLevels() }
      </div>
    )
  }
}
