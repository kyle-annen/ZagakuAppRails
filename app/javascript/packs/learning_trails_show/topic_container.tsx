import * as React from 'react';

import Level from './level'

export default class TopicContainer extends React.Component<any, any> {
  constructor(props){
    super(props);
    this.state = {
      topic_id: 1,
      topic_data: {},
      user_lessons: {}
    }
  }

  componentDidMount() {
    const data_node = document.getElementById('learning_trails_show_data');
    const data = JSON.parse(data_node.getAttribute('data'));
    const topic_name = data.name.split(".")[0].split("-").join(" ");
    const capitalized_topic_name = topic_name[0].toUpperCase() + topic_name.slice(1);

    this.setState({
      topic_id: data.id,
      topic_name: capitalized_topic_name,
      topic_summary: data.summary,
    });

    fetch(`/api/v1/topic/${data.id}`, {
      method: 'GET',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Cache': 'no-cache'
      },
      credentials: 'same-origin'
    }).then((response) => {
      return response.json();
    }).then((result) => {
      this.setState({
        topic_data: result.topic,
        user_lessons: result.user_lessons
      });
    });
  }

  render() {
    const level_keys = Object.keys(this.state.user_lessons);
    const levels = level_keys.map((key) => {
      return <Level level={key}
                    tasks={this.state.user_lessons[key].tasks}
                    goals={this.state.user_lessons[key].goals}
                    references={this.state.user_lessons[key].references}
                    key={key} />;
    });

    return(
      <div className="container">
        <h2 className="topic-page-summary">{this.state.topic_name}</h2>
        <p>{ this.state.topic_summary }</p>
        { levels }
      </div>
    )
  }
}
