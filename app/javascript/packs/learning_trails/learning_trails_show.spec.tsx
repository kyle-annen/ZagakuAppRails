import * as React from 'react';
import * as ReactDOM from 'react-dom';
import * as TestUtils from 'react-dom/test-utils';

const LearningTrailsShow = require('../LearningTrailsShow');

it('has the header content', () => {
  const show = TestUtils.renderIntoDocument(
      <LearningTrailsShow name='test content' />
  );

  const learningTrailsShowNode = ReactDOM.findDOMNode(show);

  expect(learningTrailsShowNode.textContent).toEqual('test content');
});