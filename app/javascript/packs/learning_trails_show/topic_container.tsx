import * as React from 'react';

import Level from './level'
import {IApi} from "../../apis/iapi";

export interface TopicContainerProps {
  id: number,
  api: IApi
}

export interface TopicContainerState {
  topic_id: number,
  topic_data: object,
  topic_name: string,
  topic_summary: string,
  user_lessons: object,
  api: IApi,
  model: string
}

export default class TopicContainer
  extends React.Component<TopicContainerProps, TopicContainerState> {
  constructor(props){
    super(props);
    this.state = {
      topic_id: this.props.id,
      topic_data: {},
      topic_name: "",
      topic_summary: "",
      user_lessons: {},
      api: this.props.api,
      model: 'topic',
    }
  }

  componentWillMount() {
    this.state.api.get(this.state.model, this.props.id)
      .then((result) => this.setContent(result));
  }

  setContent(result) {
    this.setState({
      topic_data: result.topic,
      user_lessons: result.user_lessons,
      topic_name: result.topic.name,
      topic_summary: result.topic.summary

    });
  }

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

  topicTitle() {
    if (this.state.topic_name.includes(".")) {
      let topic_name = this.state.topic_name.split('.')[0];
      return topic_name[0].toUpperCase() + topic_name.slice(1);
    } else {
      return this.state.topic_name
    }
  }

  render() {
    return(
      <div className="container">
        <h2 className="topic-page-title">{ this.topicTitle() }</h2>
        <h5 className="topic-page-summary">{ this.state.topic_summary }</h5>
        { this.renderLevels() }
        { JSON.stringify(this.state.user_lessons)}
      </div>
    )
  }
}
