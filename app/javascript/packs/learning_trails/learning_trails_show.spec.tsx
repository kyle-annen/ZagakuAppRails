import * as React from 'react';
import * as ReactDOM from 'react-dom';
import * as TestUtils from 'react-dom/test-utils';

import LearningTrailsShow from "./learning_trails_show";

it('has the header content', () => {
  const show = TestUtils.renderIntoDocument(
      <LearningTrailsShow />
  );

  const learningTrailsShowNode = ReactDOM.findDOMNode(show);

  expect(learningTrailsShowNode.textContent).toEqual('Learning trails show');
});